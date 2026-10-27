import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';

/// Owns journal photo files.
///
/// image_picker hands back a path inside the OS cache directory, which Android
/// and iOS both purge whenever they feel like it. Storing that path meant a
/// journal photo looked fine today and was a broken-image placeholder next
/// week, so every attachment is copied into the app's own documents directory
/// and referenced from there.
abstract final class PhotoStore {
  static Future<Directory> directory() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, AppConstants.journalPhotoDirName));
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  /// Copies [sourcePath] into permanent storage and returns the new path.
  /// Returns null if the copy fails, so the caller can skip the attachment
  /// rather than persist a path that will not resolve.
  static Future<String?> persist(String sourcePath) async {
    try {
      final source = File(sourcePath);
      if (!source.existsSync()) return null;
      final dir = await directory();
      final ext = p.extension(sourcePath).isEmpty
          ? '.jpg'
          : p.extension(sourcePath);
      final name = 'journal_${DateTime.now().microsecondsSinceEpoch}$ext';
      final target = File(p.join(dir.path, name));
      await source.copy(target.path);
      return target.path;
    } catch (e) {
      debugPrint('ArcCore: could not persist photo ($e)');
      return null;
    }
  }

  /// Deletes a stored photo. Silently ignores files that are already gone.
  static Future<void> remove(String path) async {
    try {
      final file = File(path);
      if (file.existsSync()) await file.delete();
    } catch (e) {
      debugPrint('ArcCore: could not delete photo ($e)');
    }
  }

  static bool exists(String path) {
    try {
      return File(path).existsSync();
    } catch (_) {
      return false;
    }
  }
}

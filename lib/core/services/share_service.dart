import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

/// core_features.share_cards
///
/// "Render a 1080x1350 clay stat card to PNG via the screenshot package and hand
/// it to the OS share sheet via share_plus. No network, no account, no backend."
class ShareService {
  ShareService();

  static const double cardWidth = 1080;
  static const double cardHeight = 1350;

  final ScreenshotController controller = ScreenshotController();

  /// Renders [widget] off-screen at the card's fixed logical size.
  Future<Uint8List?> renderCard(
    Widget widget, {
    double pixelRatio = 1.0,
  }) async {
    try {
      return await controller.captureFromWidget(
        widget,
        pixelRatio: pixelRatio,
        targetSize: const ui.Size(cardWidth, cardHeight),
        delay: const Duration(milliseconds: 40),
      );
    } catch (e) {
      debugPrint('ArcCore: share card render failed ($e)');
      return null;
    }
  }

  Future<File?> writePng(Uint8List bytes, String name) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File(p.join(dir.path, '$name.png'));
      await file.writeAsBytes(bytes);
      return file;
    } catch (e) {
      debugPrint('ArcCore: share card write failed ($e)');
      return null;
    }
  }

  Future<void> shareFiles(List<File> files, {String? text}) async {
    if (files.isEmpty) return;
    await SharePlus.instance.share(
      ShareParams(files: [for (final f in files) XFile(f.path)], text: text),
    );
  }

  Future<void> shareWidget(Widget card, String name, {String? text}) async {
    final bytes = await renderCard(card);
    if (bytes == null) return;
    final file = await writePng(bytes, name);
    if (file == null) return;
    await shareFiles([file], text: text);
  }
}

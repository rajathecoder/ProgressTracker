import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:csv/csv.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../data/models/achievement.dart';
import '../../data/models/app_settings.dart';
import '../../data/models/arc.dart';
import '../../data/models/daily_log.dart';
import '../../data/models/habit.dart';
import '../../data/models/user_profile.dart';
import '../../data/repositories/achievement_repository.dart';
import '../../data/repositories/arc_repository.dart';
import '../../data/repositories/daily_log_repository.dart';
import '../../data/repositories/habit_repository.dart';
import '../../data/repositories/profile_repository.dart';
import '../constants/app_constants.dart';
import '../utils/arc_date.dart';

/// data_integrity.backup.envelope
class BackupEnvelope {
  const BackupEnvelope({
    required this.schemaVersion,
    required this.appVersion,
    required this.exportedAt,
    required this.checksum,
    required this.encrypted,
    required this.payload,
  });

  final int schemaVersion;
  final String appVersion;
  final String exportedAt;

  /// SHA-256 of the serialised payload.
  final String checksum;
  final bool encrypted;
  final Map<String, dynamic> payload;

  Map<String, dynamic> toJson() => {
    'schema_version': schemaVersion,
    'app_version': appVersion,
    'exported_at': exportedAt,
    'checksum': checksum,
    'encrypted': encrypted,
    'payload': payload,
  };
}

/// What a restore would do, shown before anything is written.
class RestorePreview {
  const RestorePreview({
    required this.days,
    required this.habits,
    required this.journals,
    required this.achievements,
    required this.schemaVersion,
    required this.exportedAt,
    required this.encrypted,
  });

  final int days;
  final int habits;
  final int journals;
  final int achievements;
  final int schemaVersion;
  final String exportedAt;
  final bool encrypted;
}

enum RestoreError {
  none,
  checksumMismatch,
  schemaTooNew,
  badPassphrase,
  malformed,
}

class RestoreResult {
  const RestoreResult(this.error, [this.preview]);
  final RestoreError error;
  final RestorePreview? preview;
  bool get ok => error == RestoreError.none;
}

/// offline_strategy + data_integrity.backup / restore
///
/// Everything here is local files only. Nothing is uploaded, and the AES key is
/// derived from the passphrase on every use - never stored.
class BackupService {
  BackupService({
    required this.habits,
    required this.logs,
    required this.profiles,
    required this.arcs,
    required this.achievements,
  });

  final HabitRepository habits;
  final DailyLogRepository logs;
  final ProfileRepository profiles;
  final ArcRepository arcs;
  final AchievementRepository achievements;

  Future<Directory> backupDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, AppConstants.backupDirName));
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  // ----------------------------------------------------------------- export

  Future<Map<String, dynamic>> buildPayload(AppSettings settings) async {
    final arcList = await arcs.all();
    final allHabits = <Habit>[];
    final allLogs = <DailyLog>[];
    for (final arc in arcList) {
      allHabits.addAll(await habits.forArc(arc.id));
      allLogs.addAll(await logs.forArc(arc.id));
    }
    final profile = await profiles.get();
    final achievementList = await achievements.all();

    return {
      'arcs': arcList.map((a) => a.toJson()).toList(),
      'habits': allHabits.map((h) => h.toJson()).toList(),
      'daily_logs': allLogs.map((l) => l.toJson()).toList(),
      'profile': profile?.toJson(),
      'achievements': achievementList.map((a) => a.toJson()).toList(),
      'settings': settings.toJson(),
    };
  }

  /// Static because it is pure: the envelope depends only on its payload, so
  /// it can be exercised without touching storage.
  static BackupEnvelope envelope(
    Map<String, dynamic> payload, {
    String? passphrase,
  }) {
    final raw = jsonEncode(payload);
    final checksum = sha256.convert(utf8.encode(raw)).toString();
    final encrypted = passphrase != null && passphrase.isNotEmpty;
    return BackupEnvelope(
      schemaVersion: AppConstants.schemaVersion,
      appVersion: AppConstants.appVersion,
      exportedAt: DateTime.now().toUtc().toIso8601String(),
      checksum: checksum,
      encrypted: encrypted,
      payload: encrypted ? {'cipher': _encrypt(raw, passphrase)} : payload,
    );
  }

  Future<File> exportJson({
    required AppSettings settings,
    String? passphrase,
    Directory? directory,
  }) async {
    final payload = await buildPayload(settings);
    final env = envelope(payload, passphrase: passphrase);
    final dir = directory ?? await backupDir();
    final stamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File(p.join(dir.path, 'arccore_backup_$stamp.json'));
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(env.toJson()),
    );
    return file;
  }

  /// data_integrity.backup.manual - "CSV (flat matrix for spreadsheets)".
  Future<File> exportCsv({
    required int arcId,
    required List<Habit> habitList,
    Directory? directory,
    String Function(Habit)? titleResolver,
  }) async {
    final logList = await logs.forArc(arcId);
    final active = habitList.where((h) => !h.isArchived).toList();

    final header = <String>[
      'date',
      'is_pre_install',
      'scheduled',
      'completed',
      'completion_rate',
      'xp',
      'multiplier',
      'shield_consumed',
      'steps',
      'mood',
      'gratitude',
      'notes',
      for (final h in active) titleResolver?.call(h) ?? _fallbackTitle(h),
    ];

    final rows = <List<dynamic>>[header];
    for (final log in logList) {
      final scheduled = log.scheduledHabitIds.length;
      var completed = 0;
      for (final id in log.scheduledHabitIds) {
        if (log.entryFor(id)?.isComplete ?? false) completed++;
      }
      rows.add([
        log.dateKey,
        log.isPreInstall,
        scheduled,
        completed,
        scheduled == 0 ? '' : (completed / scheduled).toStringAsFixed(3),
        log.totalXpEarned,
        log.multiplierApplied,
        log.shieldConsumed,
        log.stepCount,
        log.mood ?? '',
        log.gratitudeText,
        log.progressNotes,
        for (final h in active) _cellValue(log, h),
      ]);
    }

    final dir = directory ?? await backupDir();
    final stamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final file = File(p.join(dir.path, 'arccore_matrix_$stamp.csv'));
    await file.writeAsString(const CsvEncoder().convert(rows));
    return file;
  }

  static String _fallbackTitle(Habit h) =>
      h.customTitle ?? h.titleKey ?? 'habit_${h.id}';

  static String _cellValue(DailyLog log, Habit h) {
    if (!log.scheduledHabitIds.contains(h.id)) return 'n/a';
    final e = log.entryFor(h.id);
    if (e == null) return '0';
    return e.isComplete ? '1' : e.value.toString();
  }

  /// offline_strategy.auto_backup - "rolling retention of the last 7 snapshots".
  Future<File> autoBackup(AppSettings settings) async {
    final file = await exportJson(settings: settings);
    await pruneSnapshots();
    return file;
  }

  Future<void> pruneSnapshots() async {
    final dir = await backupDir();
    final files =
        dir
            .listSync()
            .whereType<File>()
            .where((f) => p.basename(f.path).startsWith('arccore_backup_'))
            .toList()
          ..sort(
            (a, b) => b.statSync().modified.compareTo(a.statSync().modified),
          );
    for (var i = AppConstants.backupRetentionCount; i < files.length; i++) {
      try {
        files[i].deleteSync();
      } catch (_) {
        // A locked file is not worth failing a background task over.
      }
    }
  }

  Future<DateTime?> lastSnapshotTime() async {
    final dir = await backupDir();
    final files = dir
        .listSync()
        .whereType<File>()
        .where((f) => p.basename(f.path).startsWith('arccore_backup_'))
        .toList();
    if (files.isEmpty) return null;
    return files
        .map((f) => f.statSync().modified)
        .reduce((a, b) => a.isAfter(b) ? a : b);
  }

  // ---------------------------------------------------------------- restore

  /// Validates and describes a backup without writing anything.
  Future<RestoreResult> inspect(File file, {String? passphrase}) async {
    Map<String, dynamic> env;
    try {
      env = Map<String, dynamic>.from(
        jsonDecode(await file.readAsString()) as Map,
      );
    } catch (_) {
      return const RestoreResult(RestoreError.malformed);
    }

    final schemaVersion = (env['schema_version'] as num?)?.toInt() ?? 0;
    if (schemaVersion > AppConstants.schemaVersion) {
      return const RestoreResult(RestoreError.schemaTooNew);
    }

    final encrypted = env['encrypted'] as bool? ?? false;
    final payload = await _decodePayload(env, passphrase);
    if (payload == null) {
      return RestoreResult(
        encrypted ? RestoreError.badPassphrase : RestoreError.malformed,
      );
    }

    final checksum = env['checksum'] as String?;
    if (checksum != null &&
        sha256.convert(utf8.encode(jsonEncode(payload))).toString() !=
            checksum) {
      return const RestoreResult(RestoreError.checksumMismatch);
    }

    final logList = (payload['daily_logs'] as List?) ?? const [];
    return RestoreResult(
      RestoreError.none,
      RestorePreview(
        days: logList.length,
        habits: ((payload['habits'] as List?) ?? const []).length,
        journals: logList
            .where(
              (l) =>
                  ((l as Map)['gratitude_text'] as String? ?? '')
                      .trim()
                      .isNotEmpty ||
                  ((l)['progress_notes'] as String? ?? '').trim().isNotEmpty,
            )
            .length,
        achievements: ((payload['achievements'] as List?) ?? const []).length,
        schemaVersion: schemaVersion,
        exportedAt: env['exported_at'] as String? ?? '',
        encrypted: encrypted,
      ),
    );
  }

  /// Applies a validated backup. Takes a pre-restore snapshot first, so a bad
  /// restore is undoable (data_integrity.restore.guards).
  Future<RestoreError> restore(
    File file, {
    required bool replace,
    required AppSettings settings,
    String? passphrase,
    Directory? snapshotDirectory,
  }) async {
    final check = await inspect(file, passphrase: passphrase);
    if (!check.ok) return check.error;

    // Pre-restore snapshot, so a bad restore is undoable.
    await exportJson(settings: settings, directory: snapshotDirectory);

    final env = Map<String, dynamic>.from(
      jsonDecode(await file.readAsString()) as Map,
    );
    final payload = await _decodePayload(env, passphrase);
    if (payload == null) return RestoreError.malformed;

    if (replace) {
      await logs.deleteAll();
      await habits.deleteAll();
      await arcs.deleteAll();
      await achievements.deleteAll();
      await profiles.deleteAll();
    }

    final arcList = [
      for (final a in (payload['arcs'] as List?) ?? const [])
        Arc.fromJson(Map<String, dynamic>.from(a as Map)),
    ];
    for (final a in arcList) {
      await arcs.save(a);
    }

    final habitList = [
      for (final h in (payload['habits'] as List?) ?? const [])
        Habit.fromJson(Map<String, dynamic>.from(h as Map)),
    ];
    await habits.saveAll(habitList);

    final logList = [
      for (final l in (payload['daily_logs'] as List?) ?? const [])
        DailyLog.fromJson(Map<String, dynamic>.from(l as Map)),
    ];
    await logs.saveAll(logList);

    if (payload['profile'] != null) {
      await profiles.save(
        UserProfile.fromJson(
          Map<String, dynamic>.from(payload['profile'] as Map),
        ),
      );
    }

    // Imported achievement state is deliberately *not* trusted - the caller
    // recomputes it from the restored logs.
    final achievementList = [
      for (final a in (payload['achievements'] as List?) ?? const [])
        AchievementRecord.fromJson(Map<String, dynamic>.from(a as Map)),
    ];
    await achievements.saveAll(achievementList);

    return RestoreError.none;
  }

  Future<Map<String, dynamic>?> _decodePayload(
    Map<String, dynamic> env,
    String? passphrase,
  ) async {
    final raw = env['payload'];
    if (raw is! Map) return null;
    final map = Map<String, dynamic>.from(raw);
    if (!(env['encrypted'] as bool? ?? false)) return map;

    final cipher = map['cipher'] as String?;
    if (cipher == null || passphrase == null || passphrase.isEmpty) return null;
    try {
      return Map<String, dynamic>.from(
        jsonDecode(_decrypt(cipher, passphrase)) as Map,
      );
    } catch (_) {
      return null;
    }
  }

  // -------------------------------------------------------------- crypto

  /// AES-256-CBC with a SHA-256-derived key and a random IV prefixed to the
  /// ciphertext. The key is derived on every use and never persisted
  /// (offline_strategy.export_encryption).
  static String _encrypt(String plain, String passphrase) {
    final key = enc.Key(
      Uint8ListFrom(sha256.convert(utf8.encode(passphrase)).bytes),
    );
    final iv = enc.IV.fromSecureRandom(16);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final encrypted = encrypter.encrypt(plain, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  static String _decrypt(String payload, String passphrase) {
    final parts = payload.split(':');
    if (parts.length != 2) throw const FormatException('bad cipher');
    final key = enc.Key(
      Uint8ListFrom(sha256.convert(utf8.encode(passphrase)).bytes),
    );
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    return encrypter.decrypt64(parts[1], iv: enc.IV.fromBase64(parts[0]));
  }

  static String humanTimestamp(DateTime t, String locale) =>
      ArcDate.formatTimestamp(t, locale);
}

// ignore: non_constant_identifier_names
Uint8List Uint8ListFrom(List<int> bytes) => Uint8List.fromList(bytes);

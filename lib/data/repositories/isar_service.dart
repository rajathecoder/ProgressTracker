import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/achievement.dart';
import '../models/arc.dart';
import '../models/daily_log.dart';
import '../models/habit.dart';
import '../models/user_profile.dart';

/// Owns the single Isar instance.
///
/// performance_budget.startup: "Open Isar lazily and paint ClaySkeleton first."
/// The app shell renders before this resolves.
class IsarService {
  IsarService._(this.isar);

  final Isar isar;

  static IsarService? _instance;
  static IsarService? get instanceOrNull => _instance;

  static const List<CollectionSchema<dynamic>> schemas = [
    HabitSchema,
    DailyLogSchema,
    UserProfileSchema,
    ArcSchema,
    AchievementRecordSchema,
  ];

  static Future<IsarService> open({String? directoryOverride}) async {
    if (_instance != null) return _instance!;
    final dir =
        directoryOverride ?? (await getApplicationDocumentsDirectory()).path;
    final existing = Isar.getInstance();
    final isar =
        existing ?? await Isar.open(schemas, directory: dir, inspector: false);
    return _instance = IsarService._(isar);
  }

  /// Test seam: open against a temp directory with a unique name.
  static Future<IsarService> openForTest(String directory, String name) async {
    final isar = await Isar.open(
      schemas,
      directory: directory,
      name: name,
      inspector: false,
    );
    return IsarService._(isar);
  }

  Future<void> close({bool deleteFromDisk = false}) async {
    await isar.close(deleteFromDisk: deleteFromDisk);
    if (identical(_instance, this)) _instance = null;
  }

  Future<void> clearAll() => isar.writeTxn(() async => isar.clear());
}

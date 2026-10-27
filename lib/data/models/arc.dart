import 'package:isar_community/isar.dart';

part 'arc.g.dart';

abstract final class ArcStatus {
  static const active = 'active';
  static const completed = 'completed';
  static const abandoned = 'abandoned';
}

/// data_models.Arc - enables the multi-arc lifecycle. Without this the app is
/// dead the day the first arc ends (core_features.multi_arc).
@collection
class Arc {
  Id id = Isar.autoIncrement;

  String name = '';

  @Index()
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  int lengthDays = 122;

  @Index()
  String status = ArcStatus.active;

  double? finalCompletionRate;
  int? finalLevel;
  int? carriedFromArcId;

  /// Day-1 radar snapshot, for the recap overlay. Stored as five ints in
  /// StatKeys order: discipline, vitality, focus, strength, spirit.
  List<int> openingStatSnapshot = const [0, 0, 0, 0, 0];

  Arc();

  Arc.create({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.lengthDays,
    this.status = ArcStatus.active,
    this.carriedFromArcId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'start_date': startDate.toIso8601String(),
    'end_date': endDate.toIso8601String(),
    'length_days': lengthDays,
    'status': status,
    'final_completion_rate': finalCompletionRate,
    'final_level': finalLevel,
    'carried_from_arc_id': carriedFromArcId,
    'opening_stat_snapshot': openingStatSnapshot,
  };

  static Arc fromJson(Map<String, dynamic> j) => Arc()
    ..id = (j['id'] as num?)?.toInt() ?? Isar.autoIncrement
    ..name = j['name'] as String? ?? ''
    ..startDate =
        DateTime.tryParse(j['start_date'] as String? ?? '') ?? DateTime.now()
    ..endDate =
        DateTime.tryParse(j['end_date'] as String? ?? '') ?? DateTime.now()
    ..lengthDays = (j['length_days'] as num?)?.toInt() ?? 122
    ..status = j['status'] as String? ?? ArcStatus.active
    ..finalCompletionRate = (j['final_completion_rate'] as num?)?.toDouble()
    ..finalLevel = (j['final_level'] as num?)?.toInt()
    ..carriedFromArcId = (j['carried_from_arc_id'] as num?)?.toInt()
    ..openingStatSnapshot =
        (j['opening_stat_snapshot'] as List?)
            ?.map((e) => (e as num).toInt())
            .toList() ??
        const [0, 0, 0, 0, 0];
}

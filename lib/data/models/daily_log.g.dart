// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyLogCollection on Isar {
  IsarCollection<DailyLog> get dailyLogs => this.collection();
}

const DailyLogSchema = CollectionSchema(
  name: r'DailyLog',
  id: -3995615497450705259,
  properties: {
    r'arcId': PropertySchema(id: 0, name: r'arcId', type: IsarType.long),
    r'date': PropertySchema(id: 1, name: r'date', type: IsarType.dateTime),
    r'dateKey': PropertySchema(id: 2, name: r'dateKey', type: IsarType.string),
    r'entries': PropertySchema(
      id: 3,
      name: r'entries',
      type: IsarType.objectList,

      target: r'HabitEntry',
    ),
    r'focusMinutes': PropertySchema(
      id: 4,
      name: r'focusMinutes',
      type: IsarType.long,
    ),
    r'focusSessions': PropertySchema(
      id: 5,
      name: r'focusSessions',
      type: IsarType.long,
    ),
    r'gratitudeText': PropertySchema(
      id: 6,
      name: r'gratitudeText',
      type: IsarType.string,
    ),
    r'isPreInstall': PropertySchema(
      id: 7,
      name: r'isPreInstall',
      type: IsarType.bool,
    ),
    r'mood': PropertySchema(id: 8, name: r'mood', type: IsarType.long),
    r'multiplierApplied': PropertySchema(
      id: 9,
      name: r'multiplierApplied',
      type: IsarType.double,
    ),
    r'photoPaths': PropertySchema(
      id: 10,
      name: r'photoPaths',
      type: IsarType.stringList,
    ),
    r'progressNotes': PropertySchema(
      id: 11,
      name: r'progressNotes',
      type: IsarType.string,
    ),
    r'scheduledHabitIds': PropertySchema(
      id: 12,
      name: r'scheduledHabitIds',
      type: IsarType.longList,
    ),
    r'shieldConsumed': PropertySchema(
      id: 13,
      name: r'shieldConsumed',
      type: IsarType.bool,
    ),
    r'stepCount': PropertySchema(
      id: 14,
      name: r'stepCount',
      type: IsarType.long,
    ),
    r'tags': PropertySchema(id: 15, name: r'tags', type: IsarType.stringList),
    r'totalXpEarned': PropertySchema(
      id: 16,
      name: r'totalXpEarned',
      type: IsarType.long,
    ),
  },

  estimateSize: _dailyLogEstimateSize,
  serialize: _dailyLogSerialize,
  deserialize: _dailyLogDeserialize,
  deserializeProp: _dailyLogDeserializeProp,
  idName: r'id',
  indexes: {
    r'dateKey_arcId': IndexSchema(
      id: 7500563509764133852,
      name: r'dateKey_arcId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'dateKey',
          type: IndexType.hash,
          caseSensitive: true,
        ),
        IndexPropertySchema(
          name: r'arcId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'arcId': IndexSchema(
      id: -2552711638142935171,
      name: r'arcId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'arcId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {r'HabitEntry': HabitEntrySchema},

  getId: _dailyLogGetId,
  getLinks: _dailyLogGetLinks,
  attach: _dailyLogAttach,
  version: '3.3.2',
);

int _dailyLogEstimateSize(
  DailyLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dateKey.length * 3;
  bytesCount += 3 + object.entries.length * 3;
  {
    final offsets = allOffsets[HabitEntry]!;
    for (var i = 0; i < object.entries.length; i++) {
      final value = object.entries[i];
      bytesCount += HabitEntrySchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.gratitudeText.length * 3;
  bytesCount += 3 + object.photoPaths.length * 3;
  {
    for (var i = 0; i < object.photoPaths.length; i++) {
      final value = object.photoPaths[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.progressNotes.length * 3;
  bytesCount += 3 + object.scheduledHabitIds.length * 8;
  bytesCount += 3 + object.tags.length * 3;
  {
    for (var i = 0; i < object.tags.length; i++) {
      final value = object.tags[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _dailyLogSerialize(
  DailyLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.arcId);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeString(offsets[2], object.dateKey);
  writer.writeObjectList<HabitEntry>(
    offsets[3],
    allOffsets,
    HabitEntrySchema.serialize,
    object.entries,
  );
  writer.writeLong(offsets[4], object.focusMinutes);
  writer.writeLong(offsets[5], object.focusSessions);
  writer.writeString(offsets[6], object.gratitudeText);
  writer.writeBool(offsets[7], object.isPreInstall);
  writer.writeLong(offsets[8], object.mood);
  writer.writeDouble(offsets[9], object.multiplierApplied);
  writer.writeStringList(offsets[10], object.photoPaths);
  writer.writeString(offsets[11], object.progressNotes);
  writer.writeLongList(offsets[12], object.scheduledHabitIds);
  writer.writeBool(offsets[13], object.shieldConsumed);
  writer.writeLong(offsets[14], object.stepCount);
  writer.writeStringList(offsets[15], object.tags);
  writer.writeLong(offsets[16], object.totalXpEarned);
}

DailyLog _dailyLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyLog();
  object.arcId = reader.readLong(offsets[0]);
  object.date = reader.readDateTime(offsets[1]);
  object.dateKey = reader.readString(offsets[2]);
  object.entries =
      reader.readObjectList<HabitEntry>(
        offsets[3],
        HabitEntrySchema.deserialize,
        allOffsets,
        HabitEntry(),
      ) ??
      [];
  object.focusMinutes = reader.readLong(offsets[4]);
  object.focusSessions = reader.readLong(offsets[5]);
  object.gratitudeText = reader.readString(offsets[6]);
  object.id = id;
  object.isPreInstall = reader.readBool(offsets[7]);
  object.mood = reader.readLongOrNull(offsets[8]);
  object.multiplierApplied = reader.readDouble(offsets[9]);
  object.photoPaths = reader.readStringList(offsets[10]) ?? [];
  object.progressNotes = reader.readString(offsets[11]);
  object.scheduledHabitIds = reader.readLongList(offsets[12]) ?? [];
  object.shieldConsumed = reader.readBool(offsets[13]);
  object.stepCount = reader.readLong(offsets[14]);
  object.tags = reader.readStringList(offsets[15]) ?? [];
  object.totalXpEarned = reader.readLong(offsets[16]);
  return object;
}

P _dailyLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readObjectList<HabitEntry>(
                offset,
                HabitEntrySchema.deserialize,
                allOffsets,
                HabitEntry(),
              ) ??
              [])
          as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readStringList(offset) ?? []) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readLongList(offset) ?? []) as P;
    case 13:
      return (reader.readBool(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readStringList(offset) ?? []) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyLogGetId(DailyLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyLogGetLinks(DailyLog object) {
  return [];
}

void _dailyLogAttach(IsarCollection<dynamic> col, Id id, DailyLog object) {
  object.id = id;
}

extension DailyLogByIndex on IsarCollection<DailyLog> {
  Future<DailyLog?> getByDateKeyArcId(String dateKey, int arcId) {
    return getByIndex(r'dateKey_arcId', [dateKey, arcId]);
  }

  DailyLog? getByDateKeyArcIdSync(String dateKey, int arcId) {
    return getByIndexSync(r'dateKey_arcId', [dateKey, arcId]);
  }

  Future<bool> deleteByDateKeyArcId(String dateKey, int arcId) {
    return deleteByIndex(r'dateKey_arcId', [dateKey, arcId]);
  }

  bool deleteByDateKeyArcIdSync(String dateKey, int arcId) {
    return deleteByIndexSync(r'dateKey_arcId', [dateKey, arcId]);
  }

  Future<List<DailyLog?>> getAllByDateKeyArcId(
    List<String> dateKeyValues,
    List<int> arcIdValues,
  ) {
    final len = dateKeyValues.length;
    assert(
      arcIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([dateKeyValues[i], arcIdValues[i]]);
    }

    return getAllByIndex(r'dateKey_arcId', values);
  }

  List<DailyLog?> getAllByDateKeyArcIdSync(
    List<String> dateKeyValues,
    List<int> arcIdValues,
  ) {
    final len = dateKeyValues.length;
    assert(
      arcIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([dateKeyValues[i], arcIdValues[i]]);
    }

    return getAllByIndexSync(r'dateKey_arcId', values);
  }

  Future<int> deleteAllByDateKeyArcId(
    List<String> dateKeyValues,
    List<int> arcIdValues,
  ) {
    final len = dateKeyValues.length;
    assert(
      arcIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([dateKeyValues[i], arcIdValues[i]]);
    }

    return deleteAllByIndex(r'dateKey_arcId', values);
  }

  int deleteAllByDateKeyArcIdSync(
    List<String> dateKeyValues,
    List<int> arcIdValues,
  ) {
    final len = dateKeyValues.length;
    assert(
      arcIdValues.length == len,
      'All index values must have the same length',
    );
    final values = <List<dynamic>>[];
    for (var i = 0; i < len; i++) {
      values.add([dateKeyValues[i], arcIdValues[i]]);
    }

    return deleteAllByIndexSync(r'dateKey_arcId', values);
  }

  Future<Id> putByDateKeyArcId(DailyLog object) {
    return putByIndex(r'dateKey_arcId', object);
  }

  Id putByDateKeyArcIdSync(DailyLog object, {bool saveLinks = true}) {
    return putByIndexSync(r'dateKey_arcId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDateKeyArcId(List<DailyLog> objects) {
    return putAllByIndex(r'dateKey_arcId', objects);
  }

  List<Id> putAllByDateKeyArcIdSync(
    List<DailyLog> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'dateKey_arcId', objects, saveLinks: saveLinks);
  }
}

extension DailyLogQueryWhereSort on QueryBuilder<DailyLog, DailyLog, QWhere> {
  QueryBuilder<DailyLog, DailyLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhere> anyArcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'arcId'),
      );
    });
  }
}

extension DailyLogQueryWhere on QueryBuilder<DailyLog, DailyLog, QWhereClause> {
  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> dateKeyEqualToAnyArcId(
    String dateKey,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'dateKey_arcId', value: [dateKey]),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> dateKeyNotEqualToAnyArcId(
    String dateKey,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateKey_arcId',
                lower: [],
                upper: [dateKey],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateKey_arcId',
                lower: [dateKey],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateKey_arcId',
                lower: [dateKey],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateKey_arcId',
                lower: [],
                upper: [dateKey],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> dateKeyArcIdEqualTo(
    String dateKey,
    int arcId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'dateKey_arcId',
          value: [dateKey, arcId],
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause>
  dateKeyEqualToArcIdNotEqualTo(String dateKey, int arcId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateKey_arcId',
                lower: [dateKey],
                upper: [dateKey, arcId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateKey_arcId',
                lower: [dateKey, arcId],
                includeLower: false,
                upper: [dateKey],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateKey_arcId',
                lower: [dateKey, arcId],
                includeLower: false,
                upper: [dateKey],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'dateKey_arcId',
                lower: [dateKey],
                upper: [dateKey, arcId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause>
  dateKeyEqualToArcIdGreaterThan(
    String dateKey,
    int arcId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateKey_arcId',
          lower: [dateKey, arcId],
          includeLower: include,
          upper: [dateKey],
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause>
  dateKeyEqualToArcIdLessThan(
    String dateKey,
    int arcId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateKey_arcId',
          lower: [dateKey],
          upper: [dateKey, arcId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause>
  dateKeyEqualToArcIdBetween(
    String dateKey,
    int lowerArcId,
    int upperArcId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'dateKey_arcId',
          lower: [dateKey, lowerArcId],
          includeLower: includeLower,
          upper: [dateKey, upperArcId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> dateEqualTo(
    DateTime date,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'date', value: [date]),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> dateNotEqualTo(
    DateTime date,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [],
                upper: [date],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [date],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [date],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [],
                upper: [date],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [date],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [],
          upper: [date],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [lowerDate],
          includeLower: includeLower,
          upper: [upperDate],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> arcIdEqualTo(int arcId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'arcId', value: [arcId]),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> arcIdNotEqualTo(
    int arcId,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'arcId',
                lower: [],
                upper: [arcId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'arcId',
                lower: [arcId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'arcId',
                lower: [arcId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'arcId',
                lower: [],
                upper: [arcId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> arcIdGreaterThan(
    int arcId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'arcId',
          lower: [arcId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> arcIdLessThan(
    int arcId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'arcId',
          lower: [],
          upper: [arcId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterWhereClause> arcIdBetween(
    int lowerArcId,
    int upperArcId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'arcId',
          lower: [lowerArcId],
          includeLower: includeLower,
          upper: [upperArcId],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DailyLogQueryFilter
    on QueryBuilder<DailyLog, DailyLog, QFilterCondition> {
  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> arcIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'arcId', value: value),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> arcIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'arcId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> arcIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'arcId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> arcIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'arcId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: value),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'date',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'dateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dateKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'dateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'dateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateKeyContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'dateKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateKeyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'dateKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dateKey', value: ''),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> dateKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'dateKey', value: ''),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> entriesLengthEqualTo(
    int length,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entries', length, true, length, true);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> entriesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entries', 0, true, 0, true);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> entriesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entries', 0, false, 999999, true);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> entriesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entries', 0, true, length, include);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  entriesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'entries', length, include, 999999, true);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> entriesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'entries',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> focusMinutesEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'focusMinutes', value: value),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  focusMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'focusMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> focusMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'focusMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> focusMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'focusMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> focusSessionsEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'focusSessions', value: value),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  focusSessionsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'focusSessions',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> focusSessionsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'focusSessions',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> focusSessionsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'focusSessions',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> gratitudeTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'gratitudeText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  gratitudeTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'gratitudeText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> gratitudeTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'gratitudeText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> gratitudeTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'gratitudeText',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  gratitudeTextStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'gratitudeText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> gratitudeTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'gratitudeText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> gratitudeTextContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'gratitudeText',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> gratitudeTextMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'gratitudeText',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  gratitudeTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'gratitudeText', value: ''),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  gratitudeTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'gratitudeText', value: ''),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> isPreInstallEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isPreInstall', value: value),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> moodIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'mood'),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> moodIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'mood'),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> moodEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'mood', value: value),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> moodGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'mood',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> moodLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'mood',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> moodBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'mood',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  multiplierAppliedEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'multiplierApplied',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  multiplierAppliedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'multiplierApplied',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  multiplierAppliedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'multiplierApplied',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  multiplierAppliedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'multiplierApplied',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  photoPathsElementEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'photoPaths',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  photoPathsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'photoPaths',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  photoPathsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'photoPaths',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  photoPathsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'photoPaths',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  photoPathsElementStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'photoPaths',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  photoPathsElementEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'photoPaths',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  photoPathsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'photoPaths',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  photoPathsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'photoPaths',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  photoPathsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'photoPaths', value: ''),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  photoPathsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'photoPaths', value: ''),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  photoPathsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photoPaths', length, true, length, true);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> photoPathsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photoPaths', 0, true, 0, true);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  photoPathsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photoPaths', 0, false, 999999, true);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  photoPathsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photoPaths', 0, true, length, include);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  photoPathsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'photoPaths', length, include, 999999, true);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  photoPathsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'photoPaths',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> progressNotesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'progressNotes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  progressNotesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'progressNotes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> progressNotesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'progressNotes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> progressNotesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'progressNotes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  progressNotesStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'progressNotes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> progressNotesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'progressNotes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> progressNotesContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'progressNotes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> progressNotesMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'progressNotes',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  progressNotesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'progressNotes', value: ''),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  progressNotesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'progressNotes', value: ''),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  scheduledHabitIdsElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'scheduledHabitIds', value: value),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  scheduledHabitIdsElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'scheduledHabitIds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  scheduledHabitIdsElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'scheduledHabitIds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  scheduledHabitIdsElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'scheduledHabitIds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  scheduledHabitIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'scheduledHabitIds', length, true, length, true);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  scheduledHabitIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'scheduledHabitIds', 0, true, 0, true);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  scheduledHabitIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'scheduledHabitIds', 0, false, 999999, true);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  scheduledHabitIdsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'scheduledHabitIds', 0, true, length, include);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  scheduledHabitIdsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledHabitIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  scheduledHabitIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'scheduledHabitIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> shieldConsumedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'shieldConsumed', value: value),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> stepCountEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'stepCount', value: value),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> stepCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'stepCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> stepCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'stepCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> stepCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'stepCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> tagsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  tagsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> tagsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> tagsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tags',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> tagsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> tagsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> tagsElementContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'tags',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> tagsElementMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'tags',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> tagsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tags', value: ''),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  tagsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'tags', value: ''),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> tagsLengthEqualTo(
    int length,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', length, true, length, true);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> tagsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', 0, true, 0, true);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> tagsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', 0, false, 999999, true);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> tagsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', 0, true, length, include);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> tagsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'tags', length, include, 999999, true);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> tagsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'tags',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> totalXpEarnedEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalXpEarned', value: value),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition>
  totalXpEarnedGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalXpEarned',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> totalXpEarnedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalXpEarned',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> totalXpEarnedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalXpEarned',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DailyLogQueryObject
    on QueryBuilder<DailyLog, DailyLog, QFilterCondition> {
  QueryBuilder<DailyLog, DailyLog, QAfterFilterCondition> entriesElement(
    FilterQuery<HabitEntry> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'entries');
    });
  }
}

extension DailyLogQueryLinks
    on QueryBuilder<DailyLog, DailyLog, QFilterCondition> {}

extension DailyLogQuerySortBy on QueryBuilder<DailyLog, DailyLog, QSortBy> {
  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByArcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcId', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByArcIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcId', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByFocusMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusMinutes', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByFocusMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusMinutes', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByFocusSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusSessions', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByFocusSessionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusSessions', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByGratitudeText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gratitudeText', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByGratitudeTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gratitudeText', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByIsPreInstall() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPreInstall', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByIsPreInstallDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPreInstall', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByMultiplierApplied() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'multiplierApplied', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByMultiplierAppliedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'multiplierApplied', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByProgressNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressNotes', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByProgressNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressNotes', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByShieldConsumed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shieldConsumed', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByShieldConsumedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shieldConsumed', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByStepCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepCount', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByStepCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepCount', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByTotalXpEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalXpEarned', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> sortByTotalXpEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalXpEarned', Sort.desc);
    });
  }
}

extension DailyLogQuerySortThenBy
    on QueryBuilder<DailyLog, DailyLog, QSortThenBy> {
  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByArcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcId', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByArcIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcId', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByDateKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByDateKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dateKey', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByFocusMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusMinutes', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByFocusMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusMinutes', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByFocusSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusSessions', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByFocusSessionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'focusSessions', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByGratitudeText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gratitudeText', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByGratitudeTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'gratitudeText', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByIsPreInstall() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPreInstall', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByIsPreInstallDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPreInstall', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByMoodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mood', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByMultiplierApplied() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'multiplierApplied', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByMultiplierAppliedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'multiplierApplied', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByProgressNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressNotes', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByProgressNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressNotes', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByShieldConsumed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shieldConsumed', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByShieldConsumedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shieldConsumed', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByStepCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepCount', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByStepCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stepCount', Sort.desc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByTotalXpEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalXpEarned', Sort.asc);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QAfterSortBy> thenByTotalXpEarnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalXpEarned', Sort.desc);
    });
  }
}

extension DailyLogQueryWhereDistinct
    on QueryBuilder<DailyLog, DailyLog, QDistinct> {
  QueryBuilder<DailyLog, DailyLog, QDistinct> distinctByArcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'arcId');
    });
  }

  QueryBuilder<DailyLog, DailyLog, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<DailyLog, DailyLog, QDistinct> distinctByDateKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dateKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyLog, DailyLog, QDistinct> distinctByFocusMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'focusMinutes');
    });
  }

  QueryBuilder<DailyLog, DailyLog, QDistinct> distinctByFocusSessions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'focusSessions');
    });
  }

  QueryBuilder<DailyLog, DailyLog, QDistinct> distinctByGratitudeText({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'gratitudeText',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QDistinct> distinctByIsPreInstall() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPreInstall');
    });
  }

  QueryBuilder<DailyLog, DailyLog, QDistinct> distinctByMood() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mood');
    });
  }

  QueryBuilder<DailyLog, DailyLog, QDistinct> distinctByMultiplierApplied() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'multiplierApplied');
    });
  }

  QueryBuilder<DailyLog, DailyLog, QDistinct> distinctByPhotoPaths() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'photoPaths');
    });
  }

  QueryBuilder<DailyLog, DailyLog, QDistinct> distinctByProgressNotes({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'progressNotes',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<DailyLog, DailyLog, QDistinct> distinctByScheduledHabitIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledHabitIds');
    });
  }

  QueryBuilder<DailyLog, DailyLog, QDistinct> distinctByShieldConsumed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shieldConsumed');
    });
  }

  QueryBuilder<DailyLog, DailyLog, QDistinct> distinctByStepCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stepCount');
    });
  }

  QueryBuilder<DailyLog, DailyLog, QDistinct> distinctByTags() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tags');
    });
  }

  QueryBuilder<DailyLog, DailyLog, QDistinct> distinctByTotalXpEarned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalXpEarned');
    });
  }
}

extension DailyLogQueryProperty
    on QueryBuilder<DailyLog, DailyLog, QQueryProperty> {
  QueryBuilder<DailyLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyLog, int, QQueryOperations> arcIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'arcId');
    });
  }

  QueryBuilder<DailyLog, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DailyLog, String, QQueryOperations> dateKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dateKey');
    });
  }

  QueryBuilder<DailyLog, List<HabitEntry>, QQueryOperations> entriesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entries');
    });
  }

  QueryBuilder<DailyLog, int, QQueryOperations> focusMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'focusMinutes');
    });
  }

  QueryBuilder<DailyLog, int, QQueryOperations> focusSessionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'focusSessions');
    });
  }

  QueryBuilder<DailyLog, String, QQueryOperations> gratitudeTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'gratitudeText');
    });
  }

  QueryBuilder<DailyLog, bool, QQueryOperations> isPreInstallProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPreInstall');
    });
  }

  QueryBuilder<DailyLog, int?, QQueryOperations> moodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mood');
    });
  }

  QueryBuilder<DailyLog, double, QQueryOperations> multiplierAppliedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'multiplierApplied');
    });
  }

  QueryBuilder<DailyLog, List<String>, QQueryOperations> photoPathsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'photoPaths');
    });
  }

  QueryBuilder<DailyLog, String, QQueryOperations> progressNotesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progressNotes');
    });
  }

  QueryBuilder<DailyLog, List<int>, QQueryOperations>
  scheduledHabitIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledHabitIds');
    });
  }

  QueryBuilder<DailyLog, bool, QQueryOperations> shieldConsumedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shieldConsumed');
    });
  }

  QueryBuilder<DailyLog, int, QQueryOperations> stepCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stepCount');
    });
  }

  QueryBuilder<DailyLog, List<String>, QQueryOperations> tagsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tags');
    });
  }

  QueryBuilder<DailyLog, int, QQueryOperations> totalXpEarnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalXpEarned');
    });
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAchievementRecordCollection on Isar {
  IsarCollection<AchievementRecord> get achievementRecords => this.collection();
}

const AchievementRecordSchema = CollectionSchema(
  name: r'AchievementRecord',
  id: -1070024795934703256,
  properties: {
    r'arcId': PropertySchema(id: 0, name: r'arcId', type: IsarType.long),
    r'key': PropertySchema(id: 1, name: r'key', type: IsarType.string),
    r'progressCurrent': PropertySchema(
      id: 2,
      name: r'progressCurrent',
      type: IsarType.long,
    ),
    r'progressTarget': PropertySchema(
      id: 3,
      name: r'progressTarget',
      type: IsarType.long,
    ),
    r'unlockedAt': PropertySchema(
      id: 4,
      name: r'unlockedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _achievementRecordEstimateSize,
  serialize: _achievementRecordSerialize,
  deserialize: _achievementRecordDeserialize,
  deserializeProp: _achievementRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'key': IndexSchema(
      id: -4906094122524121629,
      name: r'key',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'key',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _achievementRecordGetId,
  getLinks: _achievementRecordGetLinks,
  attach: _achievementRecordAttach,
  version: '3.3.2',
);

int _achievementRecordEstimateSize(
  AchievementRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  return bytesCount;
}

void _achievementRecordSerialize(
  AchievementRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.arcId);
  writer.writeString(offsets[1], object.key);
  writer.writeLong(offsets[2], object.progressCurrent);
  writer.writeLong(offsets[3], object.progressTarget);
  writer.writeDateTime(offsets[4], object.unlockedAt);
}

AchievementRecord _achievementRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AchievementRecord();
  object.arcId = reader.readLongOrNull(offsets[0]);
  object.id = id;
  object.key = reader.readString(offsets[1]);
  object.progressCurrent = reader.readLong(offsets[2]);
  object.progressTarget = reader.readLong(offsets[3]);
  object.unlockedAt = reader.readDateTimeOrNull(offsets[4]);
  return object;
}

P _achievementRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _achievementRecordGetId(AchievementRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _achievementRecordGetLinks(
  AchievementRecord object,
) {
  return [];
}

void _achievementRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  AchievementRecord object,
) {
  object.id = id;
}

extension AchievementRecordByIndex on IsarCollection<AchievementRecord> {
  Future<AchievementRecord?> getByKey(String key) {
    return getByIndex(r'key', [key]);
  }

  AchievementRecord? getByKeySync(String key) {
    return getByIndexSync(r'key', [key]);
  }

  Future<bool> deleteByKey(String key) {
    return deleteByIndex(r'key', [key]);
  }

  bool deleteByKeySync(String key) {
    return deleteByIndexSync(r'key', [key]);
  }

  Future<List<AchievementRecord?>> getAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndex(r'key', values);
  }

  List<AchievementRecord?> getAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'key', values);
  }

  Future<int> deleteAllByKey(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'key', values);
  }

  int deleteAllByKeySync(List<String> keyValues) {
    final values = keyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'key', values);
  }

  Future<Id> putByKey(AchievementRecord object) {
    return putByIndex(r'key', object);
  }

  Id putByKeySync(AchievementRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'key', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByKey(List<AchievementRecord> objects) {
    return putAllByIndex(r'key', objects);
  }

  List<Id> putAllByKeySync(
    List<AchievementRecord> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'key', objects, saveLinks: saveLinks);
  }
}

extension AchievementRecordQueryWhereSort
    on QueryBuilder<AchievementRecord, AchievementRecord, QWhere> {
  QueryBuilder<AchievementRecord, AchievementRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AchievementRecordQueryWhere
    on QueryBuilder<AchievementRecord, AchievementRecord, QWhereClause> {
  QueryBuilder<AchievementRecord, AchievementRecord, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterWhereClause>
  idNotEqualTo(Id id) {
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

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterWhereClause>
  idBetween(
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

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterWhereClause>
  keyEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'key', value: [key]),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterWhereClause>
  keyNotEqualTo(String key) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'key',
                lower: [],
                upper: [key],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'key',
                lower: [key],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'key',
                lower: [key],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'key',
                lower: [],
                upper: [key],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension AchievementRecordQueryFilter
    on QueryBuilder<AchievementRecord, AchievementRecord, QFilterCondition> {
  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  arcIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'arcId'),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  arcIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'arcId'),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  arcIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'arcId', value: value),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  arcIdGreaterThan(int? value, {bool include = false}) {
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

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  arcIdLessThan(int? value, {bool include = false}) {
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

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  arcIdBetween(
    int? lower,
    int? upper, {
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

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  idGreaterThan(Id value, {bool include = false}) {
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

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  idLessThan(Id value, {bool include = false}) {
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

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  idBetween(
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

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  keyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  keyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  keyLessThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  keyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'key',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  keyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  keyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  keyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'key',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  keyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'key',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'key', value: ''),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  progressCurrentEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'progressCurrent', value: value),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  progressCurrentGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'progressCurrent',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  progressCurrentLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'progressCurrent',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  progressCurrentBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'progressCurrent',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  progressTargetEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'progressTarget', value: value),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  progressTargetGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'progressTarget',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  progressTargetLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'progressTarget',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  progressTargetBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'progressTarget',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  unlockedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'unlockedAt'),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  unlockedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'unlockedAt'),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  unlockedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'unlockedAt', value: value),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  unlockedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'unlockedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  unlockedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'unlockedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterFilterCondition>
  unlockedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'unlockedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AchievementRecordQueryObject
    on QueryBuilder<AchievementRecord, AchievementRecord, QFilterCondition> {}

extension AchievementRecordQueryLinks
    on QueryBuilder<AchievementRecord, AchievementRecord, QFilterCondition> {}

extension AchievementRecordQuerySortBy
    on QueryBuilder<AchievementRecord, AchievementRecord, QSortBy> {
  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy>
  sortByArcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcId', Sort.asc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy>
  sortByArcIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcId', Sort.desc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy>
  sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy>
  sortByProgressCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressCurrent', Sort.asc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy>
  sortByProgressCurrentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressCurrent', Sort.desc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy>
  sortByProgressTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressTarget', Sort.asc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy>
  sortByProgressTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressTarget', Sort.desc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy>
  sortByUnlockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.asc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy>
  sortByUnlockedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.desc);
    });
  }
}

extension AchievementRecordQuerySortThenBy
    on QueryBuilder<AchievementRecord, AchievementRecord, QSortThenBy> {
  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy>
  thenByArcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcId', Sort.asc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy>
  thenByArcIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcId', Sort.desc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy>
  thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy>
  thenByProgressCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressCurrent', Sort.asc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy>
  thenByProgressCurrentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressCurrent', Sort.desc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy>
  thenByProgressTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressTarget', Sort.asc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy>
  thenByProgressTargetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progressTarget', Sort.desc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy>
  thenByUnlockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.asc);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QAfterSortBy>
  thenByUnlockedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unlockedAt', Sort.desc);
    });
  }
}

extension AchievementRecordQueryWhereDistinct
    on QueryBuilder<AchievementRecord, AchievementRecord, QDistinct> {
  QueryBuilder<AchievementRecord, AchievementRecord, QDistinct>
  distinctByArcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'arcId');
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QDistinct> distinctByKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QDistinct>
  distinctByProgressCurrent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progressCurrent');
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QDistinct>
  distinctByProgressTarget() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progressTarget');
    });
  }

  QueryBuilder<AchievementRecord, AchievementRecord, QDistinct>
  distinctByUnlockedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unlockedAt');
    });
  }
}

extension AchievementRecordQueryProperty
    on QueryBuilder<AchievementRecord, AchievementRecord, QQueryProperty> {
  QueryBuilder<AchievementRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AchievementRecord, int?, QQueryOperations> arcIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'arcId');
    });
  }

  QueryBuilder<AchievementRecord, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<AchievementRecord, int, QQueryOperations>
  progressCurrentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progressCurrent');
    });
  }

  QueryBuilder<AchievementRecord, int, QQueryOperations>
  progressTargetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progressTarget');
    });
  }

  QueryBuilder<AchievementRecord, DateTime?, QQueryOperations>
  unlockedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unlockedAt');
    });
  }
}

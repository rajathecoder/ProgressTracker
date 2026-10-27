// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHabitCollection on Isar {
  IsarCollection<Habit> get habits => this.collection();
}

const HabitSchema = CollectionSchema(
  name: r'Habit',
  id: 3896650575830519340,
  properties: {
    r'activeWeekdays': PropertySchema(
      id: 0,
      name: r'activeWeekdays',
      type: IsarType.longList,
    ),
    r'arcId': PropertySchema(id: 1, name: r'arcId', type: IsarType.long),
    r'archivedAt': PropertySchema(
      id: 2,
      name: r'archivedAt',
      type: IsarType.dateTime,
    ),
    r'category': PropertySchema(
      id: 3,
      name: r'category',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'customTitle': PropertySchema(
      id: 5,
      name: r'customTitle',
      type: IsarType.string,
    ),
    r'frequencyType': PropertySchema(
      id: 6,
      name: r'frequencyType',
      type: IsarType.string,
    ),
    r'frequencyValue': PropertySchema(
      id: 7,
      name: r'frequencyValue',
      type: IsarType.long,
    ),
    r'iconAssetPath': PropertySchema(
      id: 8,
      name: r'iconAssetPath',
      type: IsarType.string,
    ),
    r'iconCodePoint': PropertySchema(
      id: 9,
      name: r'iconCodePoint',
      type: IsarType.long,
    ),
    r'isArchived': PropertySchema(
      id: 10,
      name: r'isArchived',
      type: IsarType.bool,
    ),
    r'isCustom': PropertySchema(id: 11, name: r'isCustom', type: IsarType.bool),
    r'metricUnit': PropertySchema(
      id: 12,
      name: r'metricUnit',
      type: IsarType.string,
    ),
    r'reminderTime': PropertySchema(
      id: 13,
      name: r'reminderTime',
      type: IsarType.string,
    ),
    r'sortOrder': PropertySchema(
      id: 14,
      name: r'sortOrder',
      type: IsarType.long,
    ),
    r'statAttribute': PropertySchema(
      id: 15,
      name: r'statAttribute',
      type: IsarType.string,
    ),
    r'targetMetric': PropertySchema(
      id: 16,
      name: r'targetMetric',
      type: IsarType.long,
    ),
    r'titleKey': PropertySchema(
      id: 17,
      name: r'titleKey',
      type: IsarType.string,
    ),
    r'version': PropertySchema(id: 18, name: r'version', type: IsarType.long),
    r'xpReward': PropertySchema(id: 19, name: r'xpReward', type: IsarType.long),
  },

  estimateSize: _habitEstimateSize,
  serialize: _habitSerialize,
  deserialize: _habitDeserialize,
  deserializeProp: _habitDeserializeProp,
  idName: r'id',
  indexes: {
    r'category': IndexSchema(
      id: -7560358558326323820,
      name: r'category',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'category',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'statAttribute': IndexSchema(
      id: 4384650737107927303,
      name: r'statAttribute',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'statAttribute',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'isArchived': IndexSchema(
      id: 655844772568347876,
      name: r'isArchived',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isArchived',
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
  embeddedSchemas: {},

  getId: _habitGetId,
  getLinks: _habitGetLinks,
  attach: _habitAttach,
  version: '3.3.2',
);

int _habitEstimateSize(
  Habit object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.activeWeekdays.length * 8;
  bytesCount += 3 + object.category.length * 3;
  {
    final value = object.customTitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.frequencyType.length * 3;
  bytesCount += 3 + object.iconAssetPath.length * 3;
  bytesCount += 3 + object.metricUnit.length * 3;
  {
    final value = object.reminderTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.statAttribute.length * 3;
  {
    final value = object.titleKey;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _habitSerialize(
  Habit object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLongList(offsets[0], object.activeWeekdays);
  writer.writeLong(offsets[1], object.arcId);
  writer.writeDateTime(offsets[2], object.archivedAt);
  writer.writeString(offsets[3], object.category);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeString(offsets[5], object.customTitle);
  writer.writeString(offsets[6], object.frequencyType);
  writer.writeLong(offsets[7], object.frequencyValue);
  writer.writeString(offsets[8], object.iconAssetPath);
  writer.writeLong(offsets[9], object.iconCodePoint);
  writer.writeBool(offsets[10], object.isArchived);
  writer.writeBool(offsets[11], object.isCustom);
  writer.writeString(offsets[12], object.metricUnit);
  writer.writeString(offsets[13], object.reminderTime);
  writer.writeLong(offsets[14], object.sortOrder);
  writer.writeString(offsets[15], object.statAttribute);
  writer.writeLong(offsets[16], object.targetMetric);
  writer.writeString(offsets[17], object.titleKey);
  writer.writeLong(offsets[18], object.version);
  writer.writeLong(offsets[19], object.xpReward);
}

Habit _habitDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Habit();
  object.activeWeekdays = reader.readLongList(offsets[0]) ?? [];
  object.arcId = reader.readLong(offsets[1]);
  object.archivedAt = reader.readDateTimeOrNull(offsets[2]);
  object.category = reader.readString(offsets[3]);
  object.createdAt = reader.readDateTime(offsets[4]);
  object.customTitle = reader.readStringOrNull(offsets[5]);
  object.frequencyType = reader.readString(offsets[6]);
  object.frequencyValue = reader.readLong(offsets[7]);
  object.iconAssetPath = reader.readString(offsets[8]);
  object.iconCodePoint = reader.readLong(offsets[9]);
  object.id = id;
  object.isArchived = reader.readBool(offsets[10]);
  object.isCustom = reader.readBool(offsets[11]);
  object.metricUnit = reader.readString(offsets[12]);
  object.reminderTime = reader.readStringOrNull(offsets[13]);
  object.sortOrder = reader.readLong(offsets[14]);
  object.statAttribute = reader.readString(offsets[15]);
  object.targetMetric = reader.readLong(offsets[16]);
  object.titleKey = reader.readStringOrNull(offsets[17]);
  object.version = reader.readLong(offsets[18]);
  object.xpReward = reader.readLong(offsets[19]);
  return object;
}

P _habitDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongList(offset) ?? []) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readLong(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readLong(offset)) as P;
    case 19:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _habitGetId(Habit object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _habitGetLinks(Habit object) {
  return [];
}

void _habitAttach(IsarCollection<dynamic> col, Id id, Habit object) {
  object.id = id;
}

extension HabitQueryWhereSort on QueryBuilder<Habit, Habit, QWhere> {
  QueryBuilder<Habit, Habit, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhere> anyIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isArchived'),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhere> anyArcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'arcId'),
      );
    });
  }
}

extension HabitQueryWhere on QueryBuilder<Habit, Habit, QWhereClause> {
  QueryBuilder<Habit, Habit, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Habit, Habit, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> idBetween(
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

  QueryBuilder<Habit, Habit, QAfterWhereClause> categoryEqualTo(
    String category,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'category', value: [category]),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> categoryNotEqualTo(
    String category,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [],
                upper: [category],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [category],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [category],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'category',
                lower: [],
                upper: [category],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> statAttributeEqualTo(
    String statAttribute,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'statAttribute',
          value: [statAttribute],
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> statAttributeNotEqualTo(
    String statAttribute,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'statAttribute',
                lower: [],
                upper: [statAttribute],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'statAttribute',
                lower: [statAttribute],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'statAttribute',
                lower: [statAttribute],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'statAttribute',
                lower: [],
                upper: [statAttribute],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> isArchivedEqualTo(
    bool isArchived,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'isArchived', value: [isArchived]),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> isArchivedNotEqualTo(
    bool isArchived,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isArchived',
                lower: [],
                upper: [isArchived],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isArchived',
                lower: [isArchived],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isArchived',
                lower: [isArchived],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isArchived',
                lower: [],
                upper: [isArchived],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> arcIdEqualTo(int arcId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'arcId', value: [arcId]),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterWhereClause> arcIdNotEqualTo(int arcId) {
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

  QueryBuilder<Habit, Habit, QAfterWhereClause> arcIdGreaterThan(
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

  QueryBuilder<Habit, Habit, QAfterWhereClause> arcIdLessThan(
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

  QueryBuilder<Habit, Habit, QAfterWhereClause> arcIdBetween(
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

extension HabitQueryFilter on QueryBuilder<Habit, Habit, QFilterCondition> {
  QueryBuilder<Habit, Habit, QAfterFilterCondition>
  activeWeekdaysElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'activeWeekdays', value: value),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition>
  activeWeekdaysElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'activeWeekdays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition>
  activeWeekdaysElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'activeWeekdays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition>
  activeWeekdaysElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'activeWeekdays',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> activeWeekdaysLengthEqualTo(
    int length,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'activeWeekdays', length, true, length, true);
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> activeWeekdaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'activeWeekdays', 0, true, 0, true);
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> activeWeekdaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'activeWeekdays', 0, false, 999999, true);
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition>
  activeWeekdaysLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'activeWeekdays', 0, true, length, include);
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition>
  activeWeekdaysLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'activeWeekdays', length, include, 999999, true);
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> activeWeekdaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'activeWeekdays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> arcIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'arcId', value: value),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> arcIdGreaterThan(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> arcIdLessThan(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> arcIdBetween(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> archivedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'archivedAt'),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> archivedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'archivedAt'),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> archivedAtEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'archivedAt', value: value),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> archivedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'archivedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> archivedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'archivedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> archivedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'archivedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'category',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> categoryContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> categoryMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'category',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> createdAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> customTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'customTitle'),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> customTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'customTitle'),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> customTitleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'customTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> customTitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'customTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> customTitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'customTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> customTitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'customTitle',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> customTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'customTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> customTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'customTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> customTitleContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'customTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> customTitleMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'customTitle',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> customTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'customTitle', value: ''),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> customTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'customTitle', value: ''),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'frequencyType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'frequencyType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'frequencyType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'frequencyType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'frequencyType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'frequencyType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyTypeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'frequencyType',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyTypeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'frequencyType',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'frequencyType', value: ''),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'frequencyType', value: ''),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyValueEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'frequencyValue', value: value),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'frequencyValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'frequencyValue',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> frequencyValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'frequencyValue',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> iconAssetPathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'iconAssetPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> iconAssetPathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'iconAssetPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> iconAssetPathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'iconAssetPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> iconAssetPathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'iconAssetPath',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> iconAssetPathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'iconAssetPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> iconAssetPathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'iconAssetPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> iconAssetPathContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'iconAssetPath',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> iconAssetPathMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'iconAssetPath',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> iconAssetPathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'iconAssetPath', value: ''),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> iconAssetPathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'iconAssetPath', value: ''),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> iconCodePointEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'iconCodePoint', value: value),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> iconCodePointGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'iconCodePoint',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> iconCodePointLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'iconCodePoint',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> iconCodePointBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'iconCodePoint',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Habit, Habit, QAfterFilterCondition> isArchivedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isArchived', value: value),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> isCustomEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isCustom', value: value),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> metricUnitEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'metricUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> metricUnitGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'metricUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> metricUnitLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'metricUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> metricUnitBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'metricUnit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> metricUnitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'metricUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> metricUnitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'metricUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> metricUnitContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'metricUnit',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> metricUnitMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'metricUnit',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> metricUnitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'metricUnit', value: ''),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> metricUnitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'metricUnit', value: ''),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'reminderTime'),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'reminderTime'),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'reminderTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'reminderTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'reminderTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'reminderTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'reminderTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'reminderTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'reminderTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'reminderTime',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reminderTime', value: ''),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> reminderTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'reminderTime', value: ''),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> sortOrderEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sortOrder', value: value),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> sortOrderGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sortOrder',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> sortOrderLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sortOrder',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> sortOrderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sortOrder',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> statAttributeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'statAttribute',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> statAttributeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'statAttribute',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> statAttributeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'statAttribute',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> statAttributeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'statAttribute',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> statAttributeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'statAttribute',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> statAttributeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'statAttribute',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> statAttributeContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'statAttribute',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> statAttributeMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'statAttribute',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> statAttributeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'statAttribute', value: ''),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> statAttributeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'statAttribute', value: ''),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> targetMetricEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'targetMetric', value: value),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> targetMetricGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'targetMetric',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> targetMetricLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'targetMetric',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> targetMetricBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'targetMetric',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleKeyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'titleKey'),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleKeyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'titleKey'),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleKeyEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'titleKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleKeyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'titleKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleKeyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'titleKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleKeyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'titleKey',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'titleKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'titleKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleKeyContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'titleKey',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleKeyMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'titleKey',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'titleKey', value: ''),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> titleKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'titleKey', value: ''),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> versionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'version', value: value),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> versionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'version',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> versionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'version',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> versionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'version',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> xpRewardEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'xpReward', value: value),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> xpRewardGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'xpReward',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> xpRewardLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'xpReward',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Habit, Habit, QAfterFilterCondition> xpRewardBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'xpReward',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension HabitQueryObject on QueryBuilder<Habit, Habit, QFilterCondition> {}

extension HabitQueryLinks on QueryBuilder<Habit, Habit, QFilterCondition> {}

extension HabitQuerySortBy on QueryBuilder<Habit, Habit, QSortBy> {
  QueryBuilder<Habit, Habit, QAfterSortBy> sortByArcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcId', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByArcIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcId', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByArchivedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archivedAt', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByArchivedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archivedAt', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByCustomTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customTitle', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByCustomTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customTitle', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByFrequencyType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequencyType', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByFrequencyTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequencyType', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByFrequencyValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequencyValue', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByFrequencyValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequencyValue', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByIconAssetPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconAssetPath', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByIconAssetPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconAssetPath', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByIconCodePoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconCodePoint', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByIconCodePointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconCodePoint', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByIsCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByIsCustomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByMetricUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metricUnit', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByMetricUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metricUnit', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByReminderTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTime', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByReminderTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTime', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByStatAttribute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statAttribute', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByStatAttributeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statAttribute', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByTargetMetric() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetMetric', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByTargetMetricDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetMetric', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByTitleKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleKey', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByTitleKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleKey', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByXpReward() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpReward', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> sortByXpRewardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpReward', Sort.desc);
    });
  }
}

extension HabitQuerySortThenBy on QueryBuilder<Habit, Habit, QSortThenBy> {
  QueryBuilder<Habit, Habit, QAfterSortBy> thenByArcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcId', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByArcIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcId', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByArchivedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archivedAt', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByArchivedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'archivedAt', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByCustomTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customTitle', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByCustomTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customTitle', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByFrequencyType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequencyType', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByFrequencyTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequencyType', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByFrequencyValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequencyValue', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByFrequencyValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'frequencyValue', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByIconAssetPath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconAssetPath', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByIconAssetPathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconAssetPath', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByIconCodePoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconCodePoint', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByIconCodePointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconCodePoint', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByIsCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByIsCustomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByMetricUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metricUnit', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByMetricUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metricUnit', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByReminderTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTime', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByReminderTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderTime', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByStatAttribute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statAttribute', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByStatAttributeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statAttribute', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByTargetMetric() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetMetric', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByTargetMetricDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetMetric', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByTitleKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleKey', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByTitleKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'titleKey', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'version', Sort.desc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByXpReward() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpReward', Sort.asc);
    });
  }

  QueryBuilder<Habit, Habit, QAfterSortBy> thenByXpRewardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'xpReward', Sort.desc);
    });
  }
}

extension HabitQueryWhereDistinct on QueryBuilder<Habit, Habit, QDistinct> {
  QueryBuilder<Habit, Habit, QDistinct> distinctByActiveWeekdays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activeWeekdays');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByArcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'arcId');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByArchivedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'archivedAt');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByCategory({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByCustomTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByFrequencyType({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'frequencyType',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByFrequencyValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'frequencyValue');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByIconAssetPath({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'iconAssetPath',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByIconCodePoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconCodePoint');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isArchived');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByIsCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCustom');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByMetricUnit({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metricUnit', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByReminderTime({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderTime', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sortOrder');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByStatAttribute({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'statAttribute',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByTargetMetric() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetMetric');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByTitleKey({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'titleKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'version');
    });
  }

  QueryBuilder<Habit, Habit, QDistinct> distinctByXpReward() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'xpReward');
    });
  }
}

extension HabitQueryProperty on QueryBuilder<Habit, Habit, QQueryProperty> {
  QueryBuilder<Habit, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Habit, List<int>, QQueryOperations> activeWeekdaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activeWeekdays');
    });
  }

  QueryBuilder<Habit, int, QQueryOperations> arcIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'arcId');
    });
  }

  QueryBuilder<Habit, DateTime?, QQueryOperations> archivedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'archivedAt');
    });
  }

  QueryBuilder<Habit, String, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<Habit, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Habit, String?, QQueryOperations> customTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customTitle');
    });
  }

  QueryBuilder<Habit, String, QQueryOperations> frequencyTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'frequencyType');
    });
  }

  QueryBuilder<Habit, int, QQueryOperations> frequencyValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'frequencyValue');
    });
  }

  QueryBuilder<Habit, String, QQueryOperations> iconAssetPathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconAssetPath');
    });
  }

  QueryBuilder<Habit, int, QQueryOperations> iconCodePointProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconCodePoint');
    });
  }

  QueryBuilder<Habit, bool, QQueryOperations> isArchivedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isArchived');
    });
  }

  QueryBuilder<Habit, bool, QQueryOperations> isCustomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCustom');
    });
  }

  QueryBuilder<Habit, String, QQueryOperations> metricUnitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metricUnit');
    });
  }

  QueryBuilder<Habit, String?, QQueryOperations> reminderTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderTime');
    });
  }

  QueryBuilder<Habit, int, QQueryOperations> sortOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortOrder');
    });
  }

  QueryBuilder<Habit, String, QQueryOperations> statAttributeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statAttribute');
    });
  }

  QueryBuilder<Habit, int, QQueryOperations> targetMetricProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetMetric');
    });
  }

  QueryBuilder<Habit, String?, QQueryOperations> titleKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'titleKey');
    });
  }

  QueryBuilder<Habit, int, QQueryOperations> versionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'version');
    });
  }

  QueryBuilder<Habit, int, QQueryOperations> xpRewardProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'xpReward');
    });
  }
}

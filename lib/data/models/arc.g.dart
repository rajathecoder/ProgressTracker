// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arc.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetArcCollection on Isar {
  IsarCollection<Arc> get arcs => this.collection();
}

const ArcSchema = CollectionSchema(
  name: r'Arc',
  id: -1198506153915459393,
  properties: {
    r'carriedFromArcId': PropertySchema(
      id: 0,
      name: r'carriedFromArcId',
      type: IsarType.long,
    ),
    r'endDate': PropertySchema(
      id: 1,
      name: r'endDate',
      type: IsarType.dateTime,
    ),
    r'finalCompletionRate': PropertySchema(
      id: 2,
      name: r'finalCompletionRate',
      type: IsarType.double,
    ),
    r'finalLevel': PropertySchema(
      id: 3,
      name: r'finalLevel',
      type: IsarType.long,
    ),
    r'lengthDays': PropertySchema(
      id: 4,
      name: r'lengthDays',
      type: IsarType.long,
    ),
    r'name': PropertySchema(id: 5, name: r'name', type: IsarType.string),
    r'openingStatSnapshot': PropertySchema(
      id: 6,
      name: r'openingStatSnapshot',
      type: IsarType.longList,
    ),
    r'startDate': PropertySchema(
      id: 7,
      name: r'startDate',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(id: 8, name: r'status', type: IsarType.string),
  },

  estimateSize: _arcEstimateSize,
  serialize: _arcSerialize,
  deserialize: _arcDeserialize,
  deserializeProp: _arcDeserializeProp,
  idName: r'id',
  indexes: {
    r'startDate': IndexSchema(
      id: 7723980484494730382,
      name: r'startDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'startDate',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _arcGetId,
  getLinks: _arcGetLinks,
  attach: _arcAttach,
  version: '3.3.2',
);

int _arcEstimateSize(
  Arc object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.openingStatSnapshot.length * 8;
  bytesCount += 3 + object.status.length * 3;
  return bytesCount;
}

void _arcSerialize(
  Arc object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.carriedFromArcId);
  writer.writeDateTime(offsets[1], object.endDate);
  writer.writeDouble(offsets[2], object.finalCompletionRate);
  writer.writeLong(offsets[3], object.finalLevel);
  writer.writeLong(offsets[4], object.lengthDays);
  writer.writeString(offsets[5], object.name);
  writer.writeLongList(offsets[6], object.openingStatSnapshot);
  writer.writeDateTime(offsets[7], object.startDate);
  writer.writeString(offsets[8], object.status);
}

Arc _arcDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Arc();
  object.carriedFromArcId = reader.readLongOrNull(offsets[0]);
  object.endDate = reader.readDateTime(offsets[1]);
  object.finalCompletionRate = reader.readDoubleOrNull(offsets[2]);
  object.finalLevel = reader.readLongOrNull(offsets[3]);
  object.id = id;
  object.lengthDays = reader.readLong(offsets[4]);
  object.name = reader.readString(offsets[5]);
  object.openingStatSnapshot = reader.readLongList(offsets[6]) ?? [];
  object.startDate = reader.readDateTime(offsets[7]);
  object.status = reader.readString(offsets[8]);
  return object;
}

P _arcDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLongList(offset) ?? []) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _arcGetId(Arc object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _arcGetLinks(Arc object) {
  return [];
}

void _arcAttach(IsarCollection<dynamic> col, Id id, Arc object) {
  object.id = id;
}

extension ArcQueryWhereSort on QueryBuilder<Arc, Arc, QWhere> {
  QueryBuilder<Arc, Arc, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Arc, Arc, QAfterWhere> anyStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'startDate'),
      );
    });
  }
}

extension ArcQueryWhere on QueryBuilder<Arc, Arc, QWhereClause> {
  QueryBuilder<Arc, Arc, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<Arc, Arc, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Arc, Arc, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterWhereClause> idBetween(
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

  QueryBuilder<Arc, Arc, QAfterWhereClause> startDateEqualTo(
    DateTime startDate,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'startDate', value: [startDate]),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterWhereClause> startDateNotEqualTo(
    DateTime startDate,
  ) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'startDate',
                lower: [],
                upper: [startDate],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'startDate',
                lower: [startDate],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'startDate',
                lower: [startDate],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'startDate',
                lower: [],
                upper: [startDate],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<Arc, Arc, QAfterWhereClause> startDateGreaterThan(
    DateTime startDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'startDate',
          lower: [startDate],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterWhereClause> startDateLessThan(
    DateTime startDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'startDate',
          lower: [],
          upper: [startDate],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterWhereClause> startDateBetween(
    DateTime lowerStartDate,
    DateTime upperStartDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'startDate',
          lower: [lowerStartDate],
          includeLower: includeLower,
          upper: [upperStartDate],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterWhereClause> statusEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'status', value: [status]),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterWhereClause> statusNotEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [],
                upper: [status],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [status],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [status],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'status',
                lower: [],
                upper: [status],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension ArcQueryFilter on QueryBuilder<Arc, Arc, QFilterCondition> {
  QueryBuilder<Arc, Arc, QAfterFilterCondition> carriedFromArcIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'carriedFromArcId'),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> carriedFromArcIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'carriedFromArcId'),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> carriedFromArcIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'carriedFromArcId', value: value),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> carriedFromArcIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'carriedFromArcId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> carriedFromArcIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'carriedFromArcId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> carriedFromArcIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'carriedFromArcId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> endDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'endDate', value: value),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> endDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'endDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> endDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'endDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> endDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'endDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> finalCompletionRateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'finalCompletionRate'),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> finalCompletionRateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'finalCompletionRate'),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> finalCompletionRateEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'finalCompletionRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> finalCompletionRateGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'finalCompletionRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> finalCompletionRateLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'finalCompletionRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> finalCompletionRateBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'finalCompletionRate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> finalLevelIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'finalLevel'),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> finalLevelIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'finalLevel'),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> finalLevelEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'finalLevel', value: value),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> finalLevelGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'finalLevel',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> finalLevelLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'finalLevel',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> finalLevelBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'finalLevel',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Arc, Arc, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Arc, Arc, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Arc, Arc, QAfterFilterCondition> lengthDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lengthDays', value: value),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> lengthDaysGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lengthDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> lengthDaysLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lengthDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> lengthDaysBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lengthDays',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition>
  openingStatSnapshotElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'openingStatSnapshot', value: value),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition>
  openingStatSnapshotElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'openingStatSnapshot',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition>
  openingStatSnapshotElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'openingStatSnapshot',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition>
  openingStatSnapshotElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'openingStatSnapshot',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition>
  openingStatSnapshotLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'openingStatSnapshot',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> openingStatSnapshotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'openingStatSnapshot', 0, true, 0, true);
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition>
  openingStatSnapshotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'openingStatSnapshot', 0, false, 999999, true);
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition>
  openingStatSnapshotLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'openingStatSnapshot', 0, true, length, include);
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition>
  openingStatSnapshotLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'openingStatSnapshot',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition>
  openingStatSnapshotLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'openingStatSnapshot',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> startDateEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startDate', value: value),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> startDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> startDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> startDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> statusContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'status',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> statusMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'status',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: ''),
      );
    });
  }

  QueryBuilder<Arc, Arc, QAfterFilterCondition> statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'status', value: ''),
      );
    });
  }
}

extension ArcQueryObject on QueryBuilder<Arc, Arc, QFilterCondition> {}

extension ArcQueryLinks on QueryBuilder<Arc, Arc, QFilterCondition> {}

extension ArcQuerySortBy on QueryBuilder<Arc, Arc, QSortBy> {
  QueryBuilder<Arc, Arc, QAfterSortBy> sortByCarriedFromArcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carriedFromArcId', Sort.asc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> sortByCarriedFromArcIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carriedFromArcId', Sort.desc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> sortByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> sortByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> sortByFinalCompletionRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalCompletionRate', Sort.asc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> sortByFinalCompletionRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalCompletionRate', Sort.desc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> sortByFinalLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalLevel', Sort.asc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> sortByFinalLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalLevel', Sort.desc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> sortByLengthDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lengthDays', Sort.asc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> sortByLengthDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lengthDays', Sort.desc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> sortByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> sortByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension ArcQuerySortThenBy on QueryBuilder<Arc, Arc, QSortThenBy> {
  QueryBuilder<Arc, Arc, QAfterSortBy> thenByCarriedFromArcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carriedFromArcId', Sort.asc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> thenByCarriedFromArcIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'carriedFromArcId', Sort.desc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> thenByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.asc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> thenByEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDate', Sort.desc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> thenByFinalCompletionRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalCompletionRate', Sort.asc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> thenByFinalCompletionRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalCompletionRate', Sort.desc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> thenByFinalLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalLevel', Sort.asc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> thenByFinalLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalLevel', Sort.desc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> thenByLengthDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lengthDays', Sort.asc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> thenByLengthDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lengthDays', Sort.desc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> thenByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.asc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> thenByStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startDate', Sort.desc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Arc, Arc, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }
}

extension ArcQueryWhereDistinct on QueryBuilder<Arc, Arc, QDistinct> {
  QueryBuilder<Arc, Arc, QDistinct> distinctByCarriedFromArcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'carriedFromArcId');
    });
  }

  QueryBuilder<Arc, Arc, QDistinct> distinctByEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endDate');
    });
  }

  QueryBuilder<Arc, Arc, QDistinct> distinctByFinalCompletionRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finalCompletionRate');
    });
  }

  QueryBuilder<Arc, Arc, QDistinct> distinctByFinalLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finalLevel');
    });
  }

  QueryBuilder<Arc, Arc, QDistinct> distinctByLengthDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lengthDays');
    });
  }

  QueryBuilder<Arc, Arc, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Arc, Arc, QDistinct> distinctByOpeningStatSnapshot() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openingStatSnapshot');
    });
  }

  QueryBuilder<Arc, Arc, QDistinct> distinctByStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startDate');
    });
  }

  QueryBuilder<Arc, Arc, QDistinct> distinctByStatus({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }
}

extension ArcQueryProperty on QueryBuilder<Arc, Arc, QQueryProperty> {
  QueryBuilder<Arc, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Arc, int?, QQueryOperations> carriedFromArcIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'carriedFromArcId');
    });
  }

  QueryBuilder<Arc, DateTime, QQueryOperations> endDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endDate');
    });
  }

  QueryBuilder<Arc, double?, QQueryOperations> finalCompletionRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finalCompletionRate');
    });
  }

  QueryBuilder<Arc, int?, QQueryOperations> finalLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finalLevel');
    });
  }

  QueryBuilder<Arc, int, QQueryOperations> lengthDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lengthDays');
    });
  }

  QueryBuilder<Arc, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Arc, List<int>, QQueryOperations> openingStatSnapshotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openingStatSnapshot');
    });
  }

  QueryBuilder<Arc, DateTime, QQueryOperations> startDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startDate');
    });
  }

  QueryBuilder<Arc, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }
}

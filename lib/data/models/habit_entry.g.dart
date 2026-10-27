// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_entry.dart';

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const HabitEntrySchema = Schema(
  name: r'HabitEntry',
  id: -4242304331580288944,
  properties: {
    r'awardedXp': PropertySchema(
      id: 0,
      name: r'awardedXp',
      type: IsarType.long,
    ),
    r'completionRatio': PropertySchema(
      id: 1,
      name: r'completionRatio',
      type: IsarType.double,
    ),
    r'habitId': PropertySchema(id: 2, name: r'habitId', type: IsarType.long),
    r'habitVersion': PropertySchema(
      id: 3,
      name: r'habitVersion',
      type: IsarType.long,
    ),
    r'isComplete': PropertySchema(
      id: 4,
      name: r'isComplete',
      type: IsarType.bool,
    ),
    r'loggedAt': PropertySchema(
      id: 5,
      name: r'loggedAt',
      type: IsarType.dateTime,
    ),
    r'loggedLate': PropertySchema(
      id: 6,
      name: r'loggedLate',
      type: IsarType.bool,
    ),
    r'targetAtTime': PropertySchema(
      id: 7,
      name: r'targetAtTime',
      type: IsarType.double,
    ),
    r'value': PropertySchema(id: 8, name: r'value', type: IsarType.double),
  },

  estimateSize: _habitEntryEstimateSize,
  serialize: _habitEntrySerialize,
  deserialize: _habitEntryDeserialize,
  deserializeProp: _habitEntryDeserializeProp,
);

int _habitEntryEstimateSize(
  HabitEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _habitEntrySerialize(
  HabitEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.awardedXp);
  writer.writeDouble(offsets[1], object.completionRatio);
  writer.writeLong(offsets[2], object.habitId);
  writer.writeLong(offsets[3], object.habitVersion);
  writer.writeBool(offsets[4], object.isComplete);
  writer.writeDateTime(offsets[5], object.loggedAt);
  writer.writeBool(offsets[6], object.loggedLate);
  writer.writeDouble(offsets[7], object.targetAtTime);
  writer.writeDouble(offsets[8], object.value);
}

HabitEntry _habitEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HabitEntry();
  object.awardedXp = reader.readLong(offsets[0]);
  object.completionRatio = reader.readDouble(offsets[1]);
  object.habitId = reader.readLong(offsets[2]);
  object.habitVersion = reader.readLong(offsets[3]);
  object.isComplete = reader.readBool(offsets[4]);
  object.loggedAt = reader.readDateTime(offsets[5]);
  object.loggedLate = reader.readBool(offsets[6]);
  object.targetAtTime = reader.readDouble(offsets[7]);
  object.value = reader.readDouble(offsets[8]);
  return object;
}

P _habitEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension HabitEntryQueryFilter
    on QueryBuilder<HabitEntry, HabitEntry, QFilterCondition> {
  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition> awardedXpEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'awardedXp', value: value),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition>
  awardedXpGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'awardedXp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition> awardedXpLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'awardedXp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition> awardedXpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'awardedXp',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition>
  completionRatioEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'completionRatio',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition>
  completionRatioGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'completionRatio',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition>
  completionRatioLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'completionRatio',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition>
  completionRatioBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'completionRatio',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition> habitIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'habitId', value: value),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition>
  habitIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'habitId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition> habitIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'habitId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition> habitIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'habitId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition>
  habitVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'habitVersion', value: value),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition>
  habitVersionGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'habitVersion',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition>
  habitVersionLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'habitVersion',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition>
  habitVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'habitVersion',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition> isCompleteEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isComplete', value: value),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition> loggedAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'loggedAt', value: value),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition>
  loggedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'loggedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition> loggedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'loggedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition> loggedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'loggedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition> loggedLateEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'loggedLate', value: value),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition>
  targetAtTimeEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'targetAtTime',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition>
  targetAtTimeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'targetAtTime',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition>
  targetAtTimeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'targetAtTime',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition>
  targetAtTimeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'targetAtTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition> valueEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'value',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition> valueGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'value',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition> valueLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'value',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<HabitEntry, HabitEntry, QAfterFilterCondition> valueBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'value',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }
}

extension HabitEntryQueryObject
    on QueryBuilder<HabitEntry, HabitEntry, QFilterCondition> {}

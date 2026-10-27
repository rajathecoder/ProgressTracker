// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserProfileCollection on Isar {
  IsarCollection<UserProfile> get userProfiles => this.collection();
}

const UserProfileSchema = CollectionSchema(
  name: r'UserProfile',
  id: 4738427352541298891,
  properties: {
    r'arcEndDate': PropertySchema(
      id: 0,
      name: r'arcEndDate',
      type: IsarType.dateTime,
    ),
    r'arcLengthDays': PropertySchema(
      id: 1,
      name: r'arcLengthDays',
      type: IsarType.long,
    ),
    r'arcStartDate': PropertySchema(
      id: 2,
      name: r'arcStartDate',
      type: IsarType.dateTime,
    ),
    r'bestStreak': PropertySchema(
      id: 3,
      name: r'bestStreak',
      type: IsarType.long,
    ),
    r'currentArcId': PropertySchema(
      id: 4,
      name: r'currentArcId',
      type: IsarType.long,
    ),
    r'currentLevel': PropertySchema(
      id: 5,
      name: r'currentLevel',
      type: IsarType.long,
    ),
    r'currentStreak': PropertySchema(
      id: 6,
      name: r'currentStreak',
      type: IsarType.long,
    ),
    r'fullName': PropertySchema(
      id: 7,
      name: r'fullName',
      type: IsarType.string,
    ),
    r'installedAt': PropertySchema(
      id: 8,
      name: r'installedAt',
      type: IsarType.dateTime,
    ),
    r'nickname': PropertySchema(
      id: 9,
      name: r'nickname',
      type: IsarType.string,
    ),
    r'onboardingComplete': PropertySchema(
      id: 10,
      name: r'onboardingComplete',
      type: IsarType.bool,
    ),
    r'shieldsConsumedTotal': PropertySchema(
      id: 11,
      name: r'shieldsConsumedTotal',
      type: IsarType.long,
    ),
    r'shieldsHeld': PropertySchema(
      id: 12,
      name: r'shieldsHeld',
      type: IsarType.long,
    ),
    r'statScores': PropertySchema(
      id: 13,
      name: r'statScores',
      type: IsarType.object,

      target: r'StatScores',
    ),
    r'themePreference': PropertySchema(
      id: 14,
      name: r'themePreference',
      type: IsarType.string,
    ),
    r'totalXp': PropertySchema(id: 15, name: r'totalXp', type: IsarType.long),
  },

  estimateSize: _userProfileEstimateSize,
  serialize: _userProfileSerialize,
  deserialize: _userProfileDeserialize,
  deserializeProp: _userProfileDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {r'StatScores': StatScoresSchema},

  getId: _userProfileGetId,
  getLinks: _userProfileGetLinks,
  attach: _userProfileAttach,
  version: '3.3.2',
);

int _userProfileEstimateSize(
  UserProfile object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.fullName.length * 3;
  bytesCount += 3 + object.nickname.length * 3;
  bytesCount +=
      3 +
      StatScoresSchema.estimateSize(
        object.statScores,
        allOffsets[StatScores]!,
        allOffsets,
      );
  bytesCount += 3 + object.themePreference.length * 3;
  return bytesCount;
}

void _userProfileSerialize(
  UserProfile object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.arcEndDate);
  writer.writeLong(offsets[1], object.arcLengthDays);
  writer.writeDateTime(offsets[2], object.arcStartDate);
  writer.writeLong(offsets[3], object.bestStreak);
  writer.writeLong(offsets[4], object.currentArcId);
  writer.writeLong(offsets[5], object.currentLevel);
  writer.writeLong(offsets[6], object.currentStreak);
  writer.writeString(offsets[7], object.fullName);
  writer.writeDateTime(offsets[8], object.installedAt);
  writer.writeString(offsets[9], object.nickname);
  writer.writeBool(offsets[10], object.onboardingComplete);
  writer.writeLong(offsets[11], object.shieldsConsumedTotal);
  writer.writeLong(offsets[12], object.shieldsHeld);
  writer.writeObject<StatScores>(
    offsets[13],
    allOffsets,
    StatScoresSchema.serialize,
    object.statScores,
  );
  writer.writeString(offsets[14], object.themePreference);
  writer.writeLong(offsets[15], object.totalXp);
}

UserProfile _userProfileDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserProfile();
  object.arcEndDate = reader.readDateTime(offsets[0]);
  object.arcLengthDays = reader.readLong(offsets[1]);
  object.arcStartDate = reader.readDateTime(offsets[2]);
  object.bestStreak = reader.readLong(offsets[3]);
  object.currentArcId = reader.readLong(offsets[4]);
  object.currentLevel = reader.readLong(offsets[5]);
  object.currentStreak = reader.readLong(offsets[6]);
  object.fullName = reader.readString(offsets[7]);
  object.id = id;
  object.installedAt = reader.readDateTime(offsets[8]);
  object.nickname = reader.readString(offsets[9]);
  object.onboardingComplete = reader.readBool(offsets[10]);
  object.shieldsConsumedTotal = reader.readLong(offsets[11]);
  object.shieldsHeld = reader.readLong(offsets[12]);
  object.statScores =
      reader.readObjectOrNull<StatScores>(
        offsets[13],
        StatScoresSchema.deserialize,
        allOffsets,
      ) ??
      StatScores();
  object.themePreference = reader.readString(offsets[14]);
  object.totalXp = reader.readLong(offsets[15]);
  return object;
}

P _userProfileDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDateTime(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readObjectOrNull<StatScores>(
                offset,
                StatScoresSchema.deserialize,
                allOffsets,
              ) ??
              StatScores())
          as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userProfileGetId(UserProfile object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userProfileGetLinks(UserProfile object) {
  return [];
}

void _userProfileAttach(
  IsarCollection<dynamic> col,
  Id id,
  UserProfile object,
) {
  object.id = id;
}

extension UserProfileQueryWhereSort
    on QueryBuilder<UserProfile, UserProfile, QWhere> {
  QueryBuilder<UserProfile, UserProfile, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserProfileQueryWhere
    on QueryBuilder<UserProfile, UserProfile, QWhereClause> {
  QueryBuilder<UserProfile, UserProfile, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<UserProfile, UserProfile, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterWhereClause> idBetween(
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
}

extension UserProfileQueryFilter
    on QueryBuilder<UserProfile, UserProfile, QFilterCondition> {
  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  arcEndDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'arcEndDate', value: value),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  arcEndDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'arcEndDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  arcEndDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'arcEndDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  arcEndDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'arcEndDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  arcLengthDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'arcLengthDays', value: value),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  arcLengthDaysGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'arcLengthDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  arcLengthDaysLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'arcLengthDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  arcLengthDaysBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'arcLengthDays',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  arcStartDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'arcStartDate', value: value),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  arcStartDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'arcStartDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  arcStartDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'arcStartDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  arcStartDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'arcStartDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  bestStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'bestStreak', value: value),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  bestStreakGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'bestStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  bestStreakLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'bestStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  bestStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'bestStreak',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  currentArcIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'currentArcId', value: value),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  currentArcIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currentArcId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  currentArcIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currentArcId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  currentArcIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currentArcId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  currentLevelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'currentLevel', value: value),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  currentLevelGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currentLevel',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  currentLevelLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currentLevel',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  currentLevelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currentLevel',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  currentStreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'currentStreak', value: value),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  currentStreakGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currentStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  currentStreakLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currentStreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  currentStreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currentStreak',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> fullNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fullName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  fullNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fullName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  fullNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fullName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> fullNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fullName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  fullNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'fullName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  fullNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'fullName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  fullNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'fullName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> fullNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'fullName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  fullNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fullName', value: ''),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  fullNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'fullName', value: ''),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> idBetween(
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

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  installedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'installedAt', value: value),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  installedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'installedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  installedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'installedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  installedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'installedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> nicknameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'nickname',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  nicknameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'nickname',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  nicknameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'nickname',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> nicknameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'nickname',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  nicknameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'nickname',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  nicknameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'nickname',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  nicknameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'nickname',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> nicknameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'nickname',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  nicknameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'nickname', value: ''),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  nicknameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'nickname', value: ''),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  onboardingCompleteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'onboardingComplete', value: value),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  shieldsConsumedTotalEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'shieldsConsumedTotal',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  shieldsConsumedTotalGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'shieldsConsumedTotal',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  shieldsConsumedTotalLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'shieldsConsumedTotal',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  shieldsConsumedTotalBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'shieldsConsumedTotal',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  shieldsHeldEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'shieldsHeld', value: value),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  shieldsHeldGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'shieldsHeld',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  shieldsHeldLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'shieldsHeld',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  shieldsHeldBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'shieldsHeld',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  themePreferenceEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'themePreference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  themePreferenceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'themePreference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  themePreferenceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'themePreference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  themePreferenceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'themePreference',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  themePreferenceStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'themePreference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  themePreferenceEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'themePreference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  themePreferenceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'themePreference',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  themePreferenceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'themePreference',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  themePreferenceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'themePreference', value: ''),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  themePreferenceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'themePreference', value: ''),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> totalXpEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalXp', value: value),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition>
  totalXpGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalXp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> totalXpLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalXp',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> totalXpBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalXp',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension UserProfileQueryObject
    on QueryBuilder<UserProfile, UserProfile, QFilterCondition> {
  QueryBuilder<UserProfile, UserProfile, QAfterFilterCondition> statScores(
    FilterQuery<StatScores> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'statScores');
    });
  }
}

extension UserProfileQueryLinks
    on QueryBuilder<UserProfile, UserProfile, QFilterCondition> {}

extension UserProfileQuerySortBy
    on QueryBuilder<UserProfile, UserProfile, QSortBy> {
  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByArcEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcEndDate', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByArcEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcEndDate', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByArcLengthDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcLengthDays', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  sortByArcLengthDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcLengthDays', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByArcStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcStartDate', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  sortByArcStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcStartDate', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByBestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByBestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByCurrentArcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentArcId', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  sortByCurrentArcIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentArcId', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByCurrentLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLevel', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  sortByCurrentLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLevel', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  sortByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByInstalledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installedAt', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByInstalledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installedAt', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByNickname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByNicknameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  sortByOnboardingComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingComplete', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  sortByOnboardingCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingComplete', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  sortByShieldsConsumedTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shieldsConsumedTotal', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  sortByShieldsConsumedTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shieldsConsumedTotal', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByShieldsHeld() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shieldsHeld', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByShieldsHeldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shieldsHeld', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByThemePreference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themePreference', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  sortByThemePreferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themePreference', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByTotalXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalXp', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> sortByTotalXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalXp', Sort.desc);
    });
  }
}

extension UserProfileQuerySortThenBy
    on QueryBuilder<UserProfile, UserProfile, QSortThenBy> {
  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByArcEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcEndDate', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByArcEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcEndDate', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByArcLengthDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcLengthDays', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  thenByArcLengthDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcLengthDays', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByArcStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcStartDate', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  thenByArcStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'arcStartDate', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByBestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByBestStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bestStreak', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByCurrentArcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentArcId', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  thenByCurrentArcIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentArcId', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByCurrentLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLevel', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  thenByCurrentLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentLevel', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  thenByCurrentStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentStreak', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByInstalledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installedAt', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByInstalledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'installedAt', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByNickname() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByNicknameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nickname', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  thenByOnboardingComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingComplete', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  thenByOnboardingCompleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'onboardingComplete', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  thenByShieldsConsumedTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shieldsConsumedTotal', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  thenByShieldsConsumedTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shieldsConsumedTotal', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByShieldsHeld() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shieldsHeld', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByShieldsHeldDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shieldsHeld', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByThemePreference() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themePreference', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy>
  thenByThemePreferenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themePreference', Sort.desc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByTotalXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalXp', Sort.asc);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QAfterSortBy> thenByTotalXpDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalXp', Sort.desc);
    });
  }
}

extension UserProfileQueryWhereDistinct
    on QueryBuilder<UserProfile, UserProfile, QDistinct> {
  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByArcEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'arcEndDate');
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByArcLengthDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'arcLengthDays');
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByArcStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'arcStartDate');
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByBestStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bestStreak');
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByCurrentArcId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentArcId');
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByCurrentLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentLevel');
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByCurrentStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentStreak');
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByFullName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByInstalledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'installedAt');
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByNickname({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nickname', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct>
  distinctByOnboardingComplete() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'onboardingComplete');
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct>
  distinctByShieldsConsumedTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shieldsConsumedTotal');
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByShieldsHeld() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shieldsHeld');
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByThemePreference({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'themePreference',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<UserProfile, UserProfile, QDistinct> distinctByTotalXp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalXp');
    });
  }
}

extension UserProfileQueryProperty
    on QueryBuilder<UserProfile, UserProfile, QQueryProperty> {
  QueryBuilder<UserProfile, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<UserProfile, DateTime, QQueryOperations> arcEndDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'arcEndDate');
    });
  }

  QueryBuilder<UserProfile, int, QQueryOperations> arcLengthDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'arcLengthDays');
    });
  }

  QueryBuilder<UserProfile, DateTime, QQueryOperations> arcStartDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'arcStartDate');
    });
  }

  QueryBuilder<UserProfile, int, QQueryOperations> bestStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bestStreak');
    });
  }

  QueryBuilder<UserProfile, int, QQueryOperations> currentArcIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentArcId');
    });
  }

  QueryBuilder<UserProfile, int, QQueryOperations> currentLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentLevel');
    });
  }

  QueryBuilder<UserProfile, int, QQueryOperations> currentStreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentStreak');
    });
  }

  QueryBuilder<UserProfile, String, QQueryOperations> fullNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullName');
    });
  }

  QueryBuilder<UserProfile, DateTime, QQueryOperations> installedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'installedAt');
    });
  }

  QueryBuilder<UserProfile, String, QQueryOperations> nicknameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nickname');
    });
  }

  QueryBuilder<UserProfile, bool, QQueryOperations>
  onboardingCompleteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'onboardingComplete');
    });
  }

  QueryBuilder<UserProfile, int, QQueryOperations>
  shieldsConsumedTotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shieldsConsumedTotal');
    });
  }

  QueryBuilder<UserProfile, int, QQueryOperations> shieldsHeldProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shieldsHeld');
    });
  }

  QueryBuilder<UserProfile, StatScores, QQueryOperations> statScoresProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statScores');
    });
  }

  QueryBuilder<UserProfile, String, QQueryOperations>
  themePreferenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themePreference');
    });
  }

  QueryBuilder<UserProfile, int, QQueryOperations> totalXpProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalXp');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const StatScoresSchema = Schema(
  name: r'StatScores',
  id: 1227910877639974184,
  properties: {
    r'discipline': PropertySchema(
      id: 0,
      name: r'discipline',
      type: IsarType.long,
    ),
    r'focus': PropertySchema(id: 1, name: r'focus', type: IsarType.long),
    r'spirit': PropertySchema(id: 2, name: r'spirit', type: IsarType.long),
    r'strength': PropertySchema(id: 3, name: r'strength', type: IsarType.long),
    r'vitality': PropertySchema(id: 4, name: r'vitality', type: IsarType.long),
  },

  estimateSize: _statScoresEstimateSize,
  serialize: _statScoresSerialize,
  deserialize: _statScoresDeserialize,
  deserializeProp: _statScoresDeserializeProp,
);

int _statScoresEstimateSize(
  StatScores object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _statScoresSerialize(
  StatScores object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.discipline);
  writer.writeLong(offsets[1], object.focus);
  writer.writeLong(offsets[2], object.spirit);
  writer.writeLong(offsets[3], object.strength);
  writer.writeLong(offsets[4], object.vitality);
}

StatScores _statScoresDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StatScores();
  object.discipline = reader.readLong(offsets[0]);
  object.focus = reader.readLong(offsets[1]);
  object.spirit = reader.readLong(offsets[2]);
  object.strength = reader.readLong(offsets[3]);
  object.vitality = reader.readLong(offsets[4]);
  return object;
}

P _statScoresDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension StatScoresQueryFilter
    on QueryBuilder<StatScores, StatScores, QFilterCondition> {
  QueryBuilder<StatScores, StatScores, QAfterFilterCondition> disciplineEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'discipline', value: value),
      );
    });
  }

  QueryBuilder<StatScores, StatScores, QAfterFilterCondition>
  disciplineGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'discipline',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StatScores, StatScores, QAfterFilterCondition>
  disciplineLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'discipline',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StatScores, StatScores, QAfterFilterCondition> disciplineBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'discipline',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<StatScores, StatScores, QAfterFilterCondition> focusEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'focus', value: value),
      );
    });
  }

  QueryBuilder<StatScores, StatScores, QAfterFilterCondition> focusGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'focus',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StatScores, StatScores, QAfterFilterCondition> focusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'focus',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StatScores, StatScores, QAfterFilterCondition> focusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'focus',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<StatScores, StatScores, QAfterFilterCondition> spiritEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'spirit', value: value),
      );
    });
  }

  QueryBuilder<StatScores, StatScores, QAfterFilterCondition> spiritGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'spirit',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StatScores, StatScores, QAfterFilterCondition> spiritLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'spirit',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StatScores, StatScores, QAfterFilterCondition> spiritBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'spirit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<StatScores, StatScores, QAfterFilterCondition> strengthEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'strength', value: value),
      );
    });
  }

  QueryBuilder<StatScores, StatScores, QAfterFilterCondition>
  strengthGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'strength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StatScores, StatScores, QAfterFilterCondition> strengthLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'strength',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StatScores, StatScores, QAfterFilterCondition> strengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'strength',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<StatScores, StatScores, QAfterFilterCondition> vitalityEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'vitality', value: value),
      );
    });
  }

  QueryBuilder<StatScores, StatScores, QAfterFilterCondition>
  vitalityGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'vitality',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StatScores, StatScores, QAfterFilterCondition> vitalityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'vitality',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<StatScores, StatScores, QAfterFilterCondition> vitalityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'vitality',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension StatScoresQueryObject
    on QueryBuilder<StatScores, StatScores, QFilterCondition> {}

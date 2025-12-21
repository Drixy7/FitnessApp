// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_session.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlanSessionCollection on Isar {
  IsarCollection<PlanSession> get planSessions => this.collection();
}

const PlanSessionSchema = CollectionSchema(
  name: r'PlanSession',
  id: 6035127632714118446,
  properties: {
    r'lastCompletedAbsoluteWeek': PropertySchema(
      id: 0,
      name: r'lastCompletedAbsoluteWeek',
      type: IsarType.long,
    ),
    r'lastCompletedDay': PropertySchema(
      id: 1,
      name: r'lastCompletedDay',
      type: IsarType.long,
    ),
    r'lastWorkoutDate': PropertySchema(
      id: 2,
      name: r'lastWorkoutDate',
      type: IsarType.dateTime,
    ),
    r'startTime': PropertySchema(
      id: 3,
      name: r'startTime',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _planSessionEstimateSize,
  serialize: _planSessionSerialize,
  deserialize: _planSessionDeserialize,
  deserializeProp: _planSessionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'plan': LinkSchema(
      id: -649176271668820052,
      name: r'plan',
      target: r'Plan',
      single: true,
    ),
  },
  embeddedSchemas: {},

  getId: _planSessionGetId,
  getLinks: _planSessionGetLinks,
  attach: _planSessionAttach,
  version: '3.3.0',
);

int _planSessionEstimateSize(
  PlanSession object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _planSessionSerialize(
  PlanSession object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.lastCompletedAbsoluteWeek);
  writer.writeLong(offsets[1], object.lastCompletedDay);
  writer.writeDateTime(offsets[2], object.lastWorkoutDate);
  writer.writeDateTime(offsets[3], object.startTime);
}

PlanSession _planSessionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlanSession();
  object.id = id;
  object.lastCompletedAbsoluteWeek = reader.readLong(offsets[0]);
  object.lastCompletedDay = reader.readLong(offsets[1]);
  object.lastWorkoutDate = reader.readDateTimeOrNull(offsets[2]);
  object.startTime = reader.readDateTime(offsets[3]);
  return object;
}

P _planSessionDeserializeProp<P>(
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
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _planSessionGetId(PlanSession object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _planSessionGetLinks(PlanSession object) {
  return [object.plan];
}

void _planSessionAttach(
  IsarCollection<dynamic> col,
  Id id,
  PlanSession object,
) {
  object.id = id;
  object.plan.attach(col, col.isar.collection<Plan>(), r'plan', id);
}

extension PlanSessionQueryWhereSort
    on QueryBuilder<PlanSession, PlanSession, QWhere> {
  QueryBuilder<PlanSession, PlanSession, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PlanSessionQueryWhere
    on QueryBuilder<PlanSession, PlanSession, QWhereClause> {
  QueryBuilder<PlanSession, PlanSession, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<PlanSession, PlanSession, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterWhereClause> idBetween(
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

extension PlanSessionQueryFilter
    on QueryBuilder<PlanSession, PlanSession, QFilterCondition> {
  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition>
  lastCompletedAbsoluteWeekEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'lastCompletedAbsoluteWeek',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition>
  lastCompletedAbsoluteWeekGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastCompletedAbsoluteWeek',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition>
  lastCompletedAbsoluteWeekLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastCompletedAbsoluteWeek',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition>
  lastCompletedAbsoluteWeekBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastCompletedAbsoluteWeek',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition>
  lastCompletedDayEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastCompletedDay', value: value),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition>
  lastCompletedDayGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastCompletedDay',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition>
  lastCompletedDayLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastCompletedDay',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition>
  lastCompletedDayBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastCompletedDay',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition>
  lastWorkoutDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastWorkoutDate'),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition>
  lastWorkoutDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastWorkoutDate'),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition>
  lastWorkoutDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastWorkoutDate', value: value),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition>
  lastWorkoutDateGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastWorkoutDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition>
  lastWorkoutDateLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastWorkoutDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition>
  lastWorkoutDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastWorkoutDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition>
  startTimeEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startTime', value: value),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition>
  startTimeGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startTime',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition>
  startTimeLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startTime',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition>
  startTimeBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PlanSessionQueryObject
    on QueryBuilder<PlanSession, PlanSession, QFilterCondition> {}

extension PlanSessionQueryLinks
    on QueryBuilder<PlanSession, PlanSession, QFilterCondition> {
  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition> plan(
    FilterQuery<Plan> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'plan');
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterFilterCondition> planIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'plan', 0, true, 0, true);
    });
  }
}

extension PlanSessionQuerySortBy
    on QueryBuilder<PlanSession, PlanSession, QSortBy> {
  QueryBuilder<PlanSession, PlanSession, QAfterSortBy>
  sortByLastCompletedAbsoluteWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedAbsoluteWeek', Sort.asc);
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterSortBy>
  sortByLastCompletedAbsoluteWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedAbsoluteWeek', Sort.desc);
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterSortBy>
  sortByLastCompletedDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDay', Sort.asc);
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterSortBy>
  sortByLastCompletedDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDay', Sort.desc);
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterSortBy> sortByLastWorkoutDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWorkoutDate', Sort.asc);
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterSortBy>
  sortByLastWorkoutDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWorkoutDate', Sort.desc);
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterSortBy> sortByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterSortBy> sortByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }
}

extension PlanSessionQuerySortThenBy
    on QueryBuilder<PlanSession, PlanSession, QSortThenBy> {
  QueryBuilder<PlanSession, PlanSession, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterSortBy>
  thenByLastCompletedAbsoluteWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedAbsoluteWeek', Sort.asc);
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterSortBy>
  thenByLastCompletedAbsoluteWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedAbsoluteWeek', Sort.desc);
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterSortBy>
  thenByLastCompletedDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDay', Sort.asc);
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterSortBy>
  thenByLastCompletedDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDay', Sort.desc);
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterSortBy> thenByLastWorkoutDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWorkoutDate', Sort.asc);
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterSortBy>
  thenByLastWorkoutDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastWorkoutDate', Sort.desc);
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterSortBy> thenByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.asc);
    });
  }

  QueryBuilder<PlanSession, PlanSession, QAfterSortBy> thenByStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startTime', Sort.desc);
    });
  }
}

extension PlanSessionQueryWhereDistinct
    on QueryBuilder<PlanSession, PlanSession, QDistinct> {
  QueryBuilder<PlanSession, PlanSession, QDistinct>
  distinctByLastCompletedAbsoluteWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastCompletedAbsoluteWeek');
    });
  }

  QueryBuilder<PlanSession, PlanSession, QDistinct>
  distinctByLastCompletedDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastCompletedDay');
    });
  }

  QueryBuilder<PlanSession, PlanSession, QDistinct>
  distinctByLastWorkoutDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastWorkoutDate');
    });
  }

  QueryBuilder<PlanSession, PlanSession, QDistinct> distinctByStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startTime');
    });
  }
}

extension PlanSessionQueryProperty
    on QueryBuilder<PlanSession, PlanSession, QQueryProperty> {
  QueryBuilder<PlanSession, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlanSession, int, QQueryOperations>
  lastCompletedAbsoluteWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastCompletedAbsoluteWeek');
    });
  }

  QueryBuilder<PlanSession, int, QQueryOperations> lastCompletedDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastCompletedDay');
    });
  }

  QueryBuilder<PlanSession, DateTime?, QQueryOperations>
  lastWorkoutDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastWorkoutDate');
    });
  }

  QueryBuilder<PlanSession, DateTime, QQueryOperations> startTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startTime');
    });
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_day.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlanDayCollection on Isar {
  IsarCollection<PlanDay> get planDays => this.collection();
}

const PlanDaySchema = CollectionSchema(
  name: r'PlanDay',
  id: -5005156141435949856,
  properties: {
    r'dayOrder': PropertySchema(id: 0, name: r'dayOrder', type: IsarType.long),
    r'name': PropertySchema(id: 1, name: r'name', type: IsarType.string),
    r'weekNumber': PropertySchema(
      id: 2,
      name: r'weekNumber',
      type: IsarType.long,
    ),
  },

  estimateSize: _planDayEstimateSize,
  serialize: _planDaySerialize,
  deserialize: _planDayDeserialize,
  deserializeProp: _planDayDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'plan': LinkSchema(
      id: 2400761834184479592,
      name: r'plan',
      target: r'Plan',
      single: true,
      linkName: r'days',
    ),
    r'exercises': LinkSchema(
      id: 2346450621964616733,
      name: r'exercises',
      target: r'PlanDayExercise',
      single: false,
    ),
  },
  embeddedSchemas: {},

  getId: _planDayGetId,
  getLinks: _planDayGetLinks,
  attach: _planDayAttach,
  version: '3.3.0',
);

int _planDayEstimateSize(
  PlanDay object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _planDaySerialize(
  PlanDay object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dayOrder);
  writer.writeString(offsets[1], object.name);
  writer.writeLong(offsets[2], object.weekNumber);
}

PlanDay _planDayDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlanDay();
  object.dayOrder = reader.readLong(offsets[0]);
  object.id = id;
  object.name = reader.readString(offsets[1]);
  object.weekNumber = reader.readLong(offsets[2]);
  return object;
}

P _planDayDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _planDayGetId(PlanDay object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _planDayGetLinks(PlanDay object) {
  return [object.plan, object.exercises];
}

void _planDayAttach(IsarCollection<dynamic> col, Id id, PlanDay object) {
  object.id = id;
  object.plan.attach(col, col.isar.collection<Plan>(), r'plan', id);
  object.exercises.attach(
    col,
    col.isar.collection<PlanDayExercise>(),
    r'exercises',
    id,
  );
}

extension PlanDayQueryWhereSort on QueryBuilder<PlanDay, PlanDay, QWhere> {
  QueryBuilder<PlanDay, PlanDay, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PlanDayQueryWhere on QueryBuilder<PlanDay, PlanDay, QWhereClause> {
  QueryBuilder<PlanDay, PlanDay, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<PlanDay, PlanDay, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterWhereClause> idBetween(
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

extension PlanDayQueryFilter
    on QueryBuilder<PlanDay, PlanDay, QFilterCondition> {
  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> dayOrderEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dayOrder', value: value),
      );
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> dayOrderGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dayOrder',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> dayOrderLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dayOrder',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> dayOrderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dayOrder',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> idBetween(
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

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> nameContains(
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

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> weekNumberEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'weekNumber', value: value),
      );
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> weekNumberGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'weekNumber',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> weekNumberLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'weekNumber',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> weekNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'weekNumber',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PlanDayQueryObject
    on QueryBuilder<PlanDay, PlanDay, QFilterCondition> {}

extension PlanDayQueryLinks
    on QueryBuilder<PlanDay, PlanDay, QFilterCondition> {
  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> plan(
    FilterQuery<Plan> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'plan');
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> planIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'plan', 0, true, 0, true);
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> exercises(
    FilterQuery<PlanDayExercise> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'exercises');
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> exercisesLengthEqualTo(
    int length,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'exercises', length, true, length, true);
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> exercisesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'exercises', 0, true, 0, true);
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> exercisesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'exercises', 0, false, 999999, true);
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> exercisesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'exercises', 0, true, length, include);
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition>
  exercisesLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'exercises', length, include, 999999, true);
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterFilterCondition> exercisesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
        r'exercises',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension PlanDayQuerySortBy on QueryBuilder<PlanDay, PlanDay, QSortBy> {
  QueryBuilder<PlanDay, PlanDay, QAfterSortBy> sortByDayOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOrder', Sort.asc);
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterSortBy> sortByDayOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOrder', Sort.desc);
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterSortBy> sortByWeekNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekNumber', Sort.asc);
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterSortBy> sortByWeekNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekNumber', Sort.desc);
    });
  }
}

extension PlanDayQuerySortThenBy
    on QueryBuilder<PlanDay, PlanDay, QSortThenBy> {
  QueryBuilder<PlanDay, PlanDay, QAfterSortBy> thenByDayOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOrder', Sort.asc);
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterSortBy> thenByDayOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayOrder', Sort.desc);
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterSortBy> thenByWeekNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekNumber', Sort.asc);
    });
  }

  QueryBuilder<PlanDay, PlanDay, QAfterSortBy> thenByWeekNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekNumber', Sort.desc);
    });
  }
}

extension PlanDayQueryWhereDistinct
    on QueryBuilder<PlanDay, PlanDay, QDistinct> {
  QueryBuilder<PlanDay, PlanDay, QDistinct> distinctByDayOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayOrder');
    });
  }

  QueryBuilder<PlanDay, PlanDay, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PlanDay, PlanDay, QDistinct> distinctByWeekNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekNumber');
    });
  }
}

extension PlanDayQueryProperty
    on QueryBuilder<PlanDay, PlanDay, QQueryProperty> {
  QueryBuilder<PlanDay, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlanDay, int, QQueryOperations> dayOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayOrder');
    });
  }

  QueryBuilder<PlanDay, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<PlanDay, int, QQueryOperations> weekNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekNumber');
    });
  }
}

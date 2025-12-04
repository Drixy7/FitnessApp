// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_day_exercise.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPlanDayExerciseCollection on Isar {
  IsarCollection<PlanDayExercise> get planDayExercises => this.collection();
}

const PlanDayExerciseSchema = CollectionSchema(
  name: r'PlanDayExercise',
  id: 5659384344242500696,
  properties: {
    r'orderIndex': PropertySchema(
      id: 0,
      name: r'orderIndex',
      type: IsarType.long,
    ),
    r'targetReps': PropertySchema(
      id: 1,
      name: r'targetReps',
      type: IsarType.long,
    ),
    r'targetSets': PropertySchema(
      id: 2,
      name: r'targetSets',
      type: IsarType.long,
    ),
  },

  estimateSize: _planDayExerciseEstimateSize,
  serialize: _planDayExerciseSerialize,
  deserialize: _planDayExerciseDeserialize,
  deserializeProp: _planDayExerciseDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'exersise': LinkSchema(
      id: -763624360612578648,
      name: r'exersise',
      target: r'Exercise',
      single: true,
    ),
    r'planDay': LinkSchema(
      id: -221638064582200495,
      name: r'planDay',
      target: r'PlanDay',
      single: false,
      linkName: r'exercises',
    ),
  },
  embeddedSchemas: {},

  getId: _planDayExerciseGetId,
  getLinks: _planDayExerciseGetLinks,
  attach: _planDayExerciseAttach,
  version: '3.3.0',
);

int _planDayExerciseEstimateSize(
  PlanDayExercise object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _planDayExerciseSerialize(
  PlanDayExercise object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.orderIndex);
  writer.writeLong(offsets[1], object.targetReps);
  writer.writeLong(offsets[2], object.targetSets);
}

PlanDayExercise _planDayExerciseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PlanDayExercise();
  object.id = id;
  object.orderIndex = reader.readLong(offsets[0]);
  object.targetReps = reader.readLong(offsets[1]);
  object.targetSets = reader.readLong(offsets[2]);
  return object;
}

P _planDayExerciseDeserializeProp<P>(
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
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _planDayExerciseGetId(PlanDayExercise object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _planDayExerciseGetLinks(PlanDayExercise object) {
  return [object.exersise, object.planDay];
}

void _planDayExerciseAttach(
  IsarCollection<dynamic> col,
  Id id,
  PlanDayExercise object,
) {
  object.id = id;
  object.exersise.attach(col, col.isar.collection<Exercise>(), r'exersise', id);
  object.planDay.attach(col, col.isar.collection<PlanDay>(), r'planDay', id);
}

extension PlanDayExerciseQueryWhereSort
    on QueryBuilder<PlanDayExercise, PlanDayExercise, QWhere> {
  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PlanDayExerciseQueryWhere
    on QueryBuilder<PlanDayExercise, PlanDayExercise, QWhereClause> {
  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterWhereClause>
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

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterWhereClause> idBetween(
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

extension PlanDayExerciseQueryFilter
    on QueryBuilder<PlanDayExercise, PlanDayExercise, QFilterCondition> {
  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
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

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
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

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
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

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  orderIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'orderIndex', value: value),
      );
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  orderIndexGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'orderIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  orderIndexLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'orderIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  orderIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'orderIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  targetRepsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'targetReps', value: value),
      );
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  targetRepsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'targetReps',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  targetRepsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'targetReps',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  targetRepsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'targetReps',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  targetSetsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'targetSets', value: value),
      );
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  targetSetsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'targetSets',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  targetSetsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'targetSets',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  targetSetsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'targetSets',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PlanDayExerciseQueryObject
    on QueryBuilder<PlanDayExercise, PlanDayExercise, QFilterCondition> {}

extension PlanDayExerciseQueryLinks
    on QueryBuilder<PlanDayExercise, PlanDayExercise, QFilterCondition> {
  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  exersise(FilterQuery<Exercise> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'exersise');
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  exersiseIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'exersise', 0, true, 0, true);
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition> planDay(
    FilterQuery<PlanDay> q,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'planDay');
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  planDayLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'planDay', length, true, length, true);
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  planDayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'planDay', 0, true, 0, true);
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  planDayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'planDay', 0, false, 999999, true);
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  planDayLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'planDay', 0, true, length, include);
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  planDayLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'planDay', length, include, 999999, true);
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterFilterCondition>
  planDayLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
        r'planDay',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension PlanDayExerciseQuerySortBy
    on QueryBuilder<PlanDayExercise, PlanDayExercise, QSortBy> {
  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterSortBy>
  sortByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.asc);
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterSortBy>
  sortByOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.desc);
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterSortBy>
  sortByTargetReps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetReps', Sort.asc);
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterSortBy>
  sortByTargetRepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetReps', Sort.desc);
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterSortBy>
  sortByTargetSets() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSets', Sort.asc);
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterSortBy>
  sortByTargetSetsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSets', Sort.desc);
    });
  }
}

extension PlanDayExerciseQuerySortThenBy
    on QueryBuilder<PlanDayExercise, PlanDayExercise, QSortThenBy> {
  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterSortBy>
  thenByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.asc);
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterSortBy>
  thenByOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.desc);
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterSortBy>
  thenByTargetReps() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetReps', Sort.asc);
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterSortBy>
  thenByTargetRepsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetReps', Sort.desc);
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterSortBy>
  thenByTargetSets() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSets', Sort.asc);
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QAfterSortBy>
  thenByTargetSetsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetSets', Sort.desc);
    });
  }
}

extension PlanDayExerciseQueryWhereDistinct
    on QueryBuilder<PlanDayExercise, PlanDayExercise, QDistinct> {
  QueryBuilder<PlanDayExercise, PlanDayExercise, QDistinct>
  distinctByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderIndex');
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QDistinct>
  distinctByTargetReps() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetReps');
    });
  }

  QueryBuilder<PlanDayExercise, PlanDayExercise, QDistinct>
  distinctByTargetSets() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetSets');
    });
  }
}

extension PlanDayExerciseQueryProperty
    on QueryBuilder<PlanDayExercise, PlanDayExercise, QQueryProperty> {
  QueryBuilder<PlanDayExercise, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PlanDayExercise, int, QQueryOperations> orderIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderIndex');
    });
  }

  QueryBuilder<PlanDayExercise, int, QQueryOperations> targetRepsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetReps');
    });
  }

  QueryBuilder<PlanDayExercise, int, QQueryOperations> targetSetsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetSets');
    });
  }
}

import 'package:fitness_app/utils/datatypes.dart';
import 'package:isar_community/isar.dart';

import 'exercise.dart';
import 'plan_day.dart';

part 'plan_day_exercise.g.dart';

@collection
class PlanDayExercise {
  Id id = Isar.autoIncrement;
  late int orderIndex;
  late int targetSets;
  @enumerated
  late RepRange targetReps;

  final exercise = IsarLink<Exercise>();
  @Backlink(to: "exercises")
  final planDay = IsarLinks<PlanDay>();
}

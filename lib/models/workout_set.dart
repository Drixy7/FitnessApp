import 'package:fitness_app/models/plan_day_exercise.dart';
import 'package:fitness_app/models/workout.dart';
import "package:fitness_app/utils/datatypes.dart";
import 'package:isar_community/isar.dart';

part 'workout_set.g.dart';

@collection
class WorkoutSet {
  Id id = Isar.autoIncrement;
  late int setNumber;
  late double weight;
  late int reps;
  @enumerated
  Rating rating = Rating.neutral;
  bool isSkipped = false;
  @Backlink(to: "sets")
  final workout = IsarLink<Workout>();
  final exercise = IsarLink<PlanDayExercise>();
}

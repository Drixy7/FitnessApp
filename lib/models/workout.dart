import 'package:fitness_app/models/plan_day.dart';
import 'package:isar_community/isar.dart';

import 'workout_set.dart';
part 'workout.g.dart';

@collection
class Workout {
  Id id = Isar.autoIncrement;
  late DateTime date;
  late String? note;

  final sets = IsarLinks<WorkoutSet>();
  final planDay = IsarLinks<PlanDay>();
}

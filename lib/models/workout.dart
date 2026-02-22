import 'package:fitness_app/models/plan_day.dart';
import 'package:fitness_app/models/plan_session.dart';
import 'package:fitness_app/utils/datatypes.dart';
import 'package:isar_community/isar.dart';

import 'workout_set.dart';

part 'workout.g.dart';

@collection
class Workout {
  Id id = Isar.autoIncrement;
  late DateTime date;
  int durationInSeconds = 0;
  String? note;
  @enumerated
  WorkoutStatus status = WorkoutStatus.planned;

  final sets = IsarLinks<WorkoutSet>();
  final planDay = IsarLink<PlanDay>();
  final planSession = IsarLink<PlanSession>();
}

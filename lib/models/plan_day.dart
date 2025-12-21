import 'package:fitness_app/models/plan_day_exercise.dart';
import 'package:isar_community/isar.dart';

import 'plan.dart';

part 'plan_day.g.dart';

@collection
class PlanDay {
  Id id = Isar.autoIncrement;
  late String name;
  String? description;
  late int weekNumber;
  late int dayOrder;

  @Backlink(to: "days")
  final plan = IsarLink<Plan>();

  final exercises = IsarLinks<PlanDayExercise>();
}

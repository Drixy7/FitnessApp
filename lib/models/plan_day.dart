import 'package:fitness_app/models/plan_day_exercise.dart';
import 'package:isar_community/isar.dart';

import 'plan.dart';

part 'plan_day.g.dart';

@collection
class PlanDay {
  Id id = Isar.autoIncrement;
  late String name;
  late String? description;
  late int weekNumber;
  late int dayOrder;
  bool isSkipped = false;
  @Backlink(to: "days")
  final plan = IsarLinks<Plan>();

  final exercises = IsarLinks<PlanDayExercise>();
}

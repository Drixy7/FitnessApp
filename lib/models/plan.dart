import 'package:fitness_app/models/plan_day.dart';
import 'package:fitness_app/utils/datatypes.dart';
import 'package:isar_community/isar.dart';

part 'plan.g.dart';

@collection
class Plan {
  Id id = Isar.autoIncrement;
  late String name;
  String? description;
  late int weeksPerCycle;
  late int daysPerWeek;
  late bool isActive;
  late bool isCustom;
  late DateTime? startedAt;
  @enumerated
  late Difficulty difficulty;
  final days = IsarLinks<PlanDay>();
}

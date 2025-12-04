import 'package:fitness_app/models/plan_day.dart';
import 'package:fitness_app/utils/enums.dart';
import 'package:isar_community/isar.dart';

part 'plan.g.dart';

@collection
class Plan {
  Id id = Isar.autoIncrement;
  late String name;
  late String? description;
  late int weeksCount;
  late int daysPerWeek;
  late bool isCustom;
  late DateTime createdAt;
  @enumerated
  late Difficulty difficulty;
  final days=IsarLinks<PlanDay>();
}

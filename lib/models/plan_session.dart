import 'package:fitness_app/models/plan.dart';
import 'package:isar_community/isar.dart';

part 'plan_session.g.dart';

@collection
class PlanSession {
  Id id = Isar.autoIncrement;
  final plan = IsarLink<Plan>();
  int lastCompletedAbsoluteWeek = 0;
  int lastCompletedDay = 0;
  late DateTime startTime;
  DateTime? endDate;
}

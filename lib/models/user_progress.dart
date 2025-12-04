import 'package:fitness_app/models/plan.dart';
import 'package:isar_community/isar.dart';

part 'user_progress.g.dart';

@collection
class UserProgress {
  Id id = Isar.autoIncrement;
  final plan = IsarLink<Plan>();
  int currentWeek = 1;
  int lastCompletedDay = 0;
  late bool isActive;
  late DateTime startTime;
  late DateTime? lastWorkoutDate;
}

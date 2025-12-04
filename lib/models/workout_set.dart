import 'package:fitness_app/models/exercise.dart';
import 'package:fitness_app/models/workout.dart';
import 'package:isar_community/isar.dart';

part 'workout_set.g.dart';


@collection
class WorkoutSet {
  Id id=Isar.autoIncrement;
  late int setNumber;
  late double weight;
  late int reps;
  late String? note;
  bool isSkipped=false;

  @Backlink(to: "sets")
  final workout=IsarLinks<Workout>();
  final exercise=IsarLinks<Exercise>();
}
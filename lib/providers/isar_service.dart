import 'package:fitness_app/utils/enums.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/exercise.dart';
import '../models/plan.dart';
import '../models/plan_day.dart';
import '../models/plan_day_exercise.dart';
import '../models/plan_session.dart';
import '../models/weight_log.dart';
import '../models/workout.dart';
import '../models/workout_set.dart';
import '../utils/constants.dart';

//Provides database service

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    //finds place where APP data is stored
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        //this is a blueprint for the database
        [
          PlanSchema,
          PlanDaySchema,
          PlanDayExerciseSchema,
          PlanSessionSchema,
          WeightLogSchema,
          WorkoutSchema,
          WorkoutSetSchema,
          ExerciseSchema,
        ],
        directory: dir.path, // tells Isar where to store data
        inspector: true, //Useful for debugging
      );
    }
    //If an instance is already open just return it, much faster than opening new one
    return Future.value(Isar.getInstance());
  }

  Future<void> seedDefaultExercises() async {
    final isar = await db;
    if (await isar.exercises.count() > 0) {
      //database already contains exercises
      return;
    }
    await isar.writeTxn(() async {
      await isar.exercises.putAll(DefaultExercises());
    });
  }

  /*Future<void> seedAnyPlan({
    required String planName,
    String? description,
    required int weeksPerCycle,
    required List<Map<String, Map<String, dynamic>>> blueprintsOfDays,
    required Map<int,String> dayOrderAndNames,
  }) async {
    final isar = await db;
  }*/

  Future<void> seedDefaultPlanA() async {
    final isar = await db;
    final Map<String, Map<String, dynamic>> blueprintA = {
      "Barbell Squat": {"sets": 2, "reps": RepRange.strength},
      "Barbell RDL": {"sets": 2, "reps": RepRange.strength},
      "Machine Hip Adduction": {
        "sets": 2,
        "reps": RepRange.extendedHypertrophy,
      },
      "Machine Hip Abduction": {
        "sets": 2,
        "reps": RepRange.extendedHypertrophy,
      },
      "Leg Extensions": {"sets": 3, "reps": RepRange.hypertrophy},
      "Laying Leg Curl": {"sets": 3, "reps": RepRange.hypertrophy},
      "Machine Standing Calf Raise": {
        "sets": 3,
        "reps": RepRange.extendedHypertrophy,
      },
    };
    final Map<String, Map<String, dynamic>> blueprintB = {
      "Bench Press": {"sets": 2, "reps": RepRange.strength},
      "Incline Machine Press": {"sets": 2, "reps": RepRange.hypertrophy},
      "Machine Pec Fly": {"sets": 2, "reps": RepRange.hypertrophy},
      "Dumbbell Lateral Raises": {
        "sets": 2,
        "reps": RepRange.extendedHypertrophy,
      },
      "Cable Rope Pushdown": {"sets": 2, "reps": RepRange.hypertrophy},
      "Cable Bar Curl": {"sets": 2, "reps": RepRange.hypertrophy},
      "Cable Wrist Curl": {"sets": 2, "reps": RepRange.highRep},
      "Machine Crunch": {"sets": 2, "reps": RepRange.hypertrophy},
    };
    final Map<String, Map<String, dynamic>> blueprintC = {
      "Machine Seated Calf Raise": {"sets": 3, "reps": RepRange.highRep},
      "Barbell Deadlift": {"sets": 2, "reps": RepRange.lowRep},
      "Seated Cable Row": {"sets": 2, "reps": RepRange.hypertrophy},
      "Lat Pulldown": {"sets": 2, "reps": RepRange.hypertrophy},
      "Cable Shrugs": {"sets": 2, "reps": RepRange.extendedHypertrophy},
      "Machine Lateral Raises": {"sets": 2, "reps": RepRange.hypertrophy},
      "Reverse fly": {"sets": 2, "reps": RepRange.extendedHypertrophy},
      "Preacher Curl": {"sets": 2, "reps": RepRange.hypertrophy},
    };
    final Map<String, Map<String, dynamic>> blueprintD = {
      "Incline Dumbbell Press": {"sets": 3, "reps": RepRange.strength},
      "Pull-Ups": {"sets": 2, "reps": RepRange.strength},
      "Dumbbell Shoulder Press": {"sets": 2, "reps": RepRange.strength},
      "Barbell Close Grip Bench Press": {"sets": 2, "reps": RepRange.strength},
      "Chest supported T Bar Row": {"sets": 2, "reps": RepRange.hypertrophy},
      "Cable Rope Overhead Triceps Extension": {
        "sets": 2,
        "reps": RepRange.hypertrophy,
      },
      "Cable Hammer Curl": {"sets": 2, "reps": RepRange.hypertrophy},
      "Machine Crunch": {"sets": 2, "reps": RepRange.hypertrophy},
      "Hanging Knee Raise": {"sets": 2, "reps": RepRange.extendedHypertrophy},
    };

    final allExercises = await isar.exercises.where().findAll();
    final exerciseMap = {for (var e in allExercises) e.name: e};
    final List<PlanDay> allPlanDays = [];
    await isar.writeTxn(() async {
      for (int week = 1; week <= 6; week++) {
        final dayA = await _createAndSavePlanDay(
          isar: isar,
          dayName: "Legs",
          weekNumber: week,
          dayOrder: 1,
          blueprint: blueprintA,
          exerciseMap: exerciseMap,
        );
        allPlanDays.add(dayA);
        final dayB = await _createAndSavePlanDay(
          isar: isar,
          dayName: "Push",
          weekNumber: week,
          dayOrder: 2,
          blueprint: blueprintB,
          exerciseMap: exerciseMap,
        );
        allPlanDays.add(dayB);
        final dayC = await _createAndSavePlanDay(
          isar: isar,
          dayName: "Pull",
          weekNumber: week,
          dayOrder: 4,
          blueprint: blueprintC,
          exerciseMap: exerciseMap,
        );
        allPlanDays.add(dayC);

        final dayD = await _createAndSavePlanDay(
          isar: isar,
          dayName: "Upper",
          weekNumber: week,
          dayOrder: 7,
          blueprint: blueprintD,
          exerciseMap: exerciseMap,
        );
        allPlanDays.add(dayD);
      }
      final finalPlan = Plan()
        ..name = "Push, Pull, Legs, Upper"
        ..description =
            "Well balanced workout plan, focused mainly on upper body, recommended for intermediate lifters with some experience, 4 working days per week every sixth week is deload. Recommended to a bulking phase "
        ..days.addAll(allPlanDays)
        ..weeksPerCycle = 6
        ..daysPerWeek = 4
        ..createdAt = DateTime.now()
        ..isActive = true
        ..isCustom = false
        ..difficulty = Difficulty.intermediate;
      await isar.plans.put(finalPlan);
      await finalPlan.days.save();
    });
  }

  Future<PlanDay> _createAndSavePlanDay({
    required Isar isar,
    required String dayName,
    required int weekNumber,
    required int dayOrder,
    required Map<String, Map<String, dynamic>> blueprint,
    required Map<String, Exercise> exerciseMap,
  }) async {
    final planDay = PlanDay()
      ..name = dayName
      ..weekNumber = weekNumber
      ..dayOrder = dayOrder;
    await isar.planDays.put(planDay);

    final List<PlanDayExercise> planDayExercises = [];
    final blueprintEntries = blueprint.entries.toList();

    for (int i = 0; i < blueprintEntries.length; i++) {
      final entry = blueprintEntries[i];
      final exerciseName = entry.key;
      final exerciseDetails = entry.value;

      int baseSets = exerciseDetails['sets'];
      RepRange repRange = exerciseDetails['reps'];
      final List<String> volumeIncrease = [
        "Barbell Squat",
        "Barbell RDL",
        "Bench Press",
        "Machine Pec fly",
        "Cable Rope Pushdown",
        "Cable Bar Curl",
        "Barbell Deadlift",
        "Seated Cable Row",
        "Lat Pulldown",
        "Reverse fly",
        "Pull-Ups",
        "Chest supported T Bar Row",
        "Cable Rope Overhead Triceps Extension",
        "Cable Hammer Curl",
      ];

      int progression = 0;

      if (weekNumber == 3 ||
          weekNumber == 4 && volumeIncrease.contains(exerciseName)) {
        progression = 1;
      } else if (weekNumber == 5) {
        baseSets = 3;
      } else if (weekNumber == 6) {
        baseSets = 2;
      }

      final planDayExercise = PlanDayExercise()
        ..exercise.value = exerciseMap[exerciseName]!
        ..targetSets = baseSets + progression
        ..orderIndex = i
        ..targetReps = repRange;
      planDayExercises.add(planDayExercise);
    }
    await isar.planDayExercises.putAll(planDayExercises);
    for (final pde in planDayExercises) {
      await pde.exercise.save();
    }
    planDay.exercises.addAll(planDayExercises);
    await planDay.exercises.save();
    return planDay;
  }

  Future<Plan?> getFirstPlan() async {
    final isar = await db;
    return isar.plans.where().findFirst();
  }

  Future<PlanSession?> getActivePlanSession() async {
    final isar = await db;
    return isar.planSessions.filter().lastWorkoutDateIsNull().findFirst();
  }

  Future<void> savePlanSession(PlanSession session) async {
    final isar = await db;
    await isar.writeTxn(() => isar.planSessions.put(session));
  }

  Future<PlanSession> createDefaultPlanSession(Plan plan) async {
    final isar = await db;
    final newSession = PlanSession()
      ..startTime = DateTime.now()
      ..plan.value = plan;
    await isar.writeTxn(() async {
      await isar.planSessions.put(newSession);
      await newSession.plan.save();
    });
    return newSession;
  }

  Future<PlanSession> createNewSession(PlanSession newSession) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.planSessions.put(newSession);
      await newSession.plan.save();
    });
    return newSession;
  }

  Future<List<PlanDay>> getDaysForWeek(int weekNumber) async {
    final isar = await db;
    return isar.planDays.filter().weekNumberEqualTo(weekNumber).findAll();
  }

  Future<Workout> saveWorkout(Workout workout) async {
    final isar = await db;
    isar.writeTxn(() async {
      await isar.workouts.put(workout);
      await workout.planDay.save();
    });
    return workout;
  }

  Future<void> saveWorkoutSet(WorkoutSet workoutSet) async {
    final isar = await db;
    isar.writeTxn(() async {
      await isar.workoutSets.put(workoutSet);
      await workoutSet.workout.save();
      await workoutSet.exercise.save();
    });
  }

  Future<List<WorkoutSet>> getSetsForExercise(
    int exerciseId,
    int workoutId,
  ) async {
    final isar = await db;
    return await isar.workoutSets
        .filter()
        .workout((q) => q.idEqualTo(workoutId))
        .and()
        .exercise((q) => q.idEqualTo(exerciseId))
        .sortBySetNumber()
        .findAll();
  }

  Future<Workout?> findWorkoutForDay(
    PlanDay day,
    DateTime startOfWeek,
    DateTime endOfWeek,
  ) async {
    final isar = await db;
    return await isar.workouts
        .filter()
        .dateBetween(
          startOfWeek,
          endOfWeek.add(Duration(days: 1)).subtract(Duration(milliseconds: 1)),
        )
        .and()
        .planDay((q) => q.idEqualTo(day.id))
        .findFirst();
  }

  Future<Workout?> findPreviousWorkout(PlanDay day, DateTime beforeDate) async {
    final isar = await db;
    return isar.workouts
        .filter()
        .planDay((q) => q.dayOrderEqualTo(day.dayOrder))
        .and()
        .dateLessThan(include: false, beforeDate)
        .sortByDateDesc()
        .findFirst();
  }

  Future<Workout?> findWorkoutForDate(DateTime date) async {
    final isar = await db;
    return isar.workouts.filter().dateEqualTo(date).findFirst();
  }

  Future<List<WorkoutSet>> findWorkoutSetsForExercise(
    Workout workout,
    PlanDayExercise exercise,
  ) async {
    final isar = await db;
    return isar.workoutSets
        .filter()
        .workout((q) => q.idEqualTo(workout.id))
        .and()
        .exercise((q) => q.idEqualTo(exercise.id))
        .sortBySetNumber()
        .findAll();
  }

  Future<void> updateWorkoutSets(List<WorkoutSet> sets) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.workoutSets.putAll(sets);
    });
  }

  Future<void> clearDatabase() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}

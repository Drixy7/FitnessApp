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
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
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
        directory: dir.path,
        inspector: true,
      );
    }
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

  Future<void> seedAnyPlan({
    required String planName,
    String? description,
    required int weeksPerCycle,
    required Map<int, Map<String, Map<String, dynamic>>> blueprintsOfDays,
    /* It maps dayOrder<int> to a parameter
    map<String,Map<>> String represents name of exercise
    Map<String,dynamic> represents parameters of exercise the string here can only be "sets" and "reps",
    exercises in this map must be in order we want to have them in training*/
    required Map<int, String>
    dayOrderAndNames, // int is dayOrder string is Name
    required Difficulty difficulty,
    required Map<int, Map<String, int>> progressionMap,
  }) async {
    final isar = await db;

    final allExercises = await isar.exercises.where().findAll();
    final exerciseMap = {for (var e in allExercises) e.name: e};

    final List<PlanDay> allPlanDays = [];
    final List<int> workingDays = dayOrderAndNames.keys.toList();
    await isar.writeTxn(() async {
      for (int week = 1; week <= weeksPerCycle; week++) {
        for (int i in workingDays) {
          final day = await _createAndSavePlanDay(
            isar: isar,
            dayName: dayOrderAndNames[i]!,
            weekNumber: week,
            deloadWeekNumber: weeksPerCycle,
            dayOrder: i,
            blueprint: blueprintsOfDays[i]!,
            exerciseMap: exerciseMap,
            progressionMap: progressionMap,
          );
          allPlanDays.add(day);
        }
      }

      final finalPlan = Plan()
        ..name = planName
        ..description = description
        ..days.addAll(allPlanDays)
        ..weeksPerCycle = weeksPerCycle
        ..daysPerWeek = workingDays.length
        ..createdAt = DateTime.now()
        ..isActive = true
        ..isCustom = false
        ..difficulty = difficulty;
      await isar.plans.put(finalPlan);
      await finalPlan.days.save();
    });
  }

  Future<void> seedDefaultPlanA() async {
    await seedAnyPlan(
      planName: PlanADefinition.name,
      weeksPerCycle: PlanADefinition.weeksPerCycle,
      blueprintsOfDays: PlanADefinition.blueprintsOfDays,
      dayOrderAndNames: PlanADefinition.dayOrderAndNames,
      difficulty: PlanADefinition.difficulty,
      progressionMap: PlanADefinition.progressionMap,
    );
  }

  Future<PlanDay> _createAndSavePlanDay({
    required Isar isar,
    required String dayName,
    required int weekNumber,
    required int deloadWeekNumber,
    required int dayOrder,
    required Map<String, Map<String, dynamic>> blueprint,
    required Map<String, Exercise> exerciseMap,
    required Map<int, Map<String, int>> progressionMap,
  }) async {
    final planDay = PlanDay()
      ..name = dayName
      ..weekNumber = weekNumber
      ..dayOrder = dayOrder;
    await isar.planDays.put(planDay);

    final List<PlanDayExercise> planDayExercises = [];
    final blueprintEntries = blueprint.entries.toList();
    final progressionWeeks = progressionMap.keys.toList();

    for (int i = 0; i < blueprintEntries.length; i++) {
      final entry = blueprintEntries[i];
      final exerciseName = entry.key;
      final exerciseDetails = entry.value;

      int baseSets = exerciseDetails['sets'];
      RepRange repRange = exerciseDetails['reps'];

      int progression = 0;

      if (progressionWeeks.contains(weekNumber)) {
        final exercisesForProgression = progressionMap[weekNumber]!.keys
            .toList();
        if (exercisesForProgression.contains(exerciseName)) {
          progression = progressionMap[weekNumber]![exerciseName]!;
        }
      }

      if (weekNumber == deloadWeekNumber) {
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

  Future<WeightLog?> findWeightLogForDate(DateTime targetDate) async {
    final isar = await db;
    DateTime targetDateMorphed = DateTime(
      targetDate.year,
      targetDate.month,
      targetDate.day,
    );

    final weightEntry = await isar.weightLogs
        .filter()
        .dateEqualTo(targetDateMorphed)
        .findFirst();
    return weightEntry;
  }

  Future<void> updateOrCreateWeightLog(WeightLog weightLog) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.weightLogs.put(weightLog);
    });
  }

  Future<void> clearDatabase() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }
}

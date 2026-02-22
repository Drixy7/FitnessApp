import 'package:fitness_app/models/custom_data_package_models.dart';
import 'package:fitness_app/utils/datatypes.dart';
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

  // seeding of database state
  Future<void> seedDefaultExercises() async {
    final isar = await db;
    if (await isar.exercises.count() > 0) {
      //database already contains exercises
      return;
    }
    await isar.writeTxn(() async {
      await isar.exercises.putAll(defaultExercises());
    });
  }

  Future<void> seedPlan({
    required String planName,
    String? description,
    required int weeksPerCycle,
    required Map<int, List<BlueprintEntry>> blueprintsOfDays,
    /* It maps dayOrder<int> to List - representing a single day */
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
          final day = await _savePlanDay(
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
        ..weeksPerCycle = weeksPerCycle
        ..daysPerWeek = workingDays.length
        ..isActive = false
        ..isCustom = false
        ..difficulty = difficulty
        ..days.addAll(allPlanDays);

      await isar.plans.put(finalPlan);
      await finalPlan.days.save();
    });
  }

  Future<void> seedDefaultPlanA() async {
    await seedPlan(
      planName: PlanADefinition.name,
      weeksPerCycle: PlanADefinition.weeksPerCycle,
      description: PlanADefinition.description,
      blueprintsOfDays: PlanADefinition.blueprintsOfDays,
      dayOrderAndNames: PlanADefinition.dayOrderAndNames,
      difficulty: PlanADefinition.difficulty,
      progressionMap: PlanADefinition.progressionMap,
    );
  }

  Future<void> seedDefaultPlanB() async {
    await seedPlan(
      planName: PlanBDefinition.name,
      weeksPerCycle: PlanBDefinition.weeksPerCycle,
      description: PlanBDefinition.description,
      blueprintsOfDays: PlanBDefinition.blueprintsOfDays,
      dayOrderAndNames: PlanBDefinition.dayOrderAndNames,
      difficulty: PlanBDefinition.difficulty,
      progressionMap: PlanBDefinition.progressionMap,
    );
  }

  Future<PlanDay> _savePlanDay({
    required Isar isar,
    required String dayName,
    required int weekNumber,
    required int deloadWeekNumber,
    required int dayOrder,
    required List<BlueprintEntry> blueprint,
    required Map<String, Exercise> exerciseMap,
    required Map<int, Map<String, int>> progressionMap,
  }) async {
    final planDay = PlanDay()
      ..name = dayName
      ..weekNumber = weekNumber
      ..dayOrder = dayOrder;
    await isar.planDays.put(planDay);

    final List<PlanDayExercise> planDayExercises = [];
    final progressionWeeks = progressionMap.keys.toList();

    for (final (int index, BlueprintEntry entry) in blueprint.indexed) {
      int baseSets = entry.sets;
      RepRange repRange = entry.reps;

      int progression = 0;

      if (progressionWeeks.contains(weekNumber)) {
        final exercisesForProgression = progressionMap[weekNumber]!.keys
            .toList();
        if (exercisesForProgression.contains(entry.exerciseName)) {
          progression = progressionMap[weekNumber]![entry.exerciseName]!;
        }
      }

      if (weekNumber == deloadWeekNumber) {
        baseSets = 2;
      }

      final planDayExercise = PlanDayExercise()
        ..exercise.value = exerciseMap[entry.exerciseName]!
        ..targetSets = baseSets + progression
        ..orderIndex = index
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

  // Plan manipulation:
  Future<Plan?> findFirstPlan() async {
    final isar = await db;
    return isar.plans.where().findFirst();
  }

  Future<void> personalisePlan(
    Plan plan,
    Map<String, int>
    dayOrderMapping, // always contains data like day.name:[1-7]
  ) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await plan.days.load();
      final List<PlanDay> daysToUpdate = plan.days.toList();
      for (final day in daysToUpdate) {
        if (dayOrderMapping.containsKey(day.name)) {
          day.dayOrder = dayOrderMapping[day.name]!;
        }
      }
      await isar.planDays.putAll(daysToUpdate);
    });
  }

  Future<List<Plan>> findAllPlans() async {
    final isar = await db;
    return isar.plans.where().findAll();
  }

  Future<List<Plan>> findAllValidPlans() async {
    final isar = await db;
    return isar.plans.filter().sessionsIsNotEmpty().findAll();
  }

  Stream<void> watchPlanChanges() async* {
    final isar = await db;
    //notifies watcher after change in table Plans
    yield* isar.plans.watchLazy();
  }

  Future<List<Exercise>> findExercisesForPlan(Plan plan) async {
    await plan.days.load();
    final allDays = plan.days.toList();
    final filteredDays = allDays.where((day) => day.weekNumber == 1);
    final List<Exercise> uniqueExercises = [];
    final Set<int> idsOfAddedExercises = {};

    for (final day in filteredDays) {
      await day.exercises.load();
      final allExercises = day.exercises.toList();
      for (final exercise in allExercises) {
        await exercise.exercise.load();
        final realExercise = exercise.exercise.value;

        if (realExercise != null &&
            !idsOfAddedExercises.contains(realExercise.id)) {
          idsOfAddedExercises.add(realExercise.id);
          uniqueExercises.add(realExercise);
        }
      }
    }
    return uniqueExercises;
  }

  Future<void> savePlan(Plan plan) async {
    final isar = await db;
    await isar.writeTxn(() async => await isar.plans.put(plan));
  }

  Future<Map<Plan, PlanSession?>> findPlansWithLatestSession() async {
    final plans = await findAllPlans();
    final Map<Plan, PlanSession?> results = {};

    for (final plan in plans) {
      final latestSession = await findLastPlanSession(plan);

      results[plan] = latestSession;
    }

    return results;
  }

  // PlanSession manipulation:
  Future<PlanSession?> findActivePlanSession() async {
    final isar = await db;
    return isar.planSessions.filter().endDateIsNull().findFirst();
  }

  Future<PlanSession?> findLastPlanSession(Plan plan) async {
    final isar = await db;
    return isar.planSessions
        .filter()
        .plan((q) => q.idEqualTo(plan.id))
        .sortByEndDateDesc()
        .findFirst();
  }

  Future<PlanSession> savePlanSession(PlanSession newSession) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.planSessions.put(newSession);
      await newSession.plan.save();
    });
    return newSession;
  }

  Future<PlanSession?> findSessionByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final isar = await db;
    return await isar.planSessions
        .filter()
        .startDateLessThan(end)
        .and()
        .group(
          (q) => q.endDateIsNull().or().endDateGreaterThan(
            start,
          ), // OR it ended after the week started
        )
        .findFirst();
  }

  Future<bool> findIfSessionExist(Plan plan) async {
    final isar = await db;
    return isar.planSessions
        .filter()
        .plan((q) => q.idEqualTo(plan.id))
        .isNotEmpty();
  }

  //PlanDay manipulation
  Future<List<PlanDay>> findDaysForWeek(int weekNumber, Plan plan) async {
    final isar = await db;
    return isar.planDays
        .filter()
        .weekNumberEqualTo(weekNumber)
        .and()
        .plan((q) => q.idEqualTo(plan.id))
        .findAll();
  }

  //Workout manipulation:
  Future<Workout> saveWorkout(Workout workout) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.workouts.put(workout);
      await workout.planDay.save();
      await workout.planSession.save();
    });
    return workout;
  }

  Future<void> skipWorkout(Workout workout) async {
    final isar = await db;
    workout.status = WorkoutStatus.skipped;
    final setsToDelete = workout.sets.map((s) => s.id).toList();
    await isar.writeTxn(() async {
      await isar.workoutSets.deleteAll(setsToDelete);
    });
    await saveWorkout(workout);
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

  Future<List<Workout>> findWorkoutsForWeek(
    DateTime startOfWeek,
    DateTime endOfWeek,
    Plan plan,
  ) async {
    final isar = await db;
    final end = endOfWeek
        .add(Duration(days: 1))
        .subtract(Duration(milliseconds: 1));
    return await isar.workouts
        .filter()
        .dateBetween(startOfWeek, end)
        .and()
        .planDay((q) => q.plan((p) => p.idEqualTo(plan.id)))
        .findAll();
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

  //Workout set manipulation:
  Future<List<WorkoutSet>> findSetsForExercise(
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

  Future<void> saveWorkoutSet(WorkoutSet workoutSet) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.workoutSets.put(workoutSet);
      await workoutSet.workout.save();
      await workoutSet.exercise.save();
    });
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

  Future<void> saveWorkoutSets(List<WorkoutSet> sets) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.workoutSets.putAll(sets);
      final List<Future> linkFutures = [];
      for (final set in sets) {
        linkFutures.add(set.workout.save());
        linkFutures.add(set.exercise.save());
      }
      await Future.wait(linkFutures);
    });
  }

  Future<void> markExerciseAsSkipped(List<WorkoutSet> sets) async {
    final isar = await db;
    WorkoutSet firstSet = sets.first;
    firstSet.isSkipped = true;
    firstSet.weight = -1;
    firstSet.reps = -1;
    await isar.writeTxn(() async {
      await isar.workoutSets.put(firstSet);
      await firstSet.workout.save();
      await firstSet.exercise.save();
      if (sets.length > 1) {
        final idsToDelete = sets.sublist(1).map((s) => s.id).toList();
        await isar.workoutSets.deleteAll(idsToDelete);
      }
    });
  }

  Future<void> markSetAsSkipped(WorkoutSet set) async {
    final isar = await db;
    set.isSkipped = true;
    set.weight = -1;
    set.reps = -1;
    await isar.writeTxn(() async {
      await isar.workoutSets.put(set);
    });
  }

  Future<void> deleteWorkoutSet(
    Workout activeWorkout,
    int setNumber,
    PlanDayExercise pde,
  ) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.workoutSets
          .filter()
          .workout((q) => q.idEqualTo(activeWorkout.id))
          .and()
          .setNumberEqualTo(setNumber)
          .and()
          .exercise((q) => q.idEqualTo(pde.id))
          .deleteAll();
    });
  }

  //Weight log manipulation
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

  Future<void> saveWeightLog(WeightLog weightLog) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.weightLogs.put(weightLog);
    });
  }

  Future<List<WeightLog>> findWeightLogsForDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final isar = await db;
    final entries = await isar.weightLogs
        .filter()
        .dateBetween(start, end)
        .sortByDate()
        .findAll();
    return entries;
  }

  // deletes whole database:
  Future<void> clearDatabase() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.clear();
    });
  }

  //todo testing methods to remove:
  // Seeding Weight Data
  Future<void> seedTestWeightLog() async {
    final isar = await db;

    final now = DateTime.now();
    // Normalize to midnight to match your app's logic
    final today = DateTime(now.year, now.month, now.day);

    // Map format: Days Ago -> Weight (kg)
    // Includes fluctuations, missing days, and a "cheat day" spike (Day 15)
    final Map<int, double> rawData = {
      30: 90.5, 29: 90.2, 28: 90.4, 27: 89.9, 26: 90.1,
      // 25: Skipped
      24: 89.8, 23: 89.7, 22: 89.5, 21: 89.6, 20: 89.3,
      19: 89.4, 18: 89.2,
      // 17: Skipped
      16: 89.5, 15: 91.2, // The Spike
      14: 90.8, 13: 90.1, 12: 89.9,
      4: 88.6, 3: 88.4, 2: 88.3, 1: 88.0, 0: 87.8,
    };

    final List<WeightLog> logsToAdd = [];

    rawData.forEach((daysAgo, weightVal) {
      final date = today.subtract(Duration(days: daysAgo));

      final log = WeightLog()
        ..date = date
        ..weight = weightVal;

      logsToAdd.add(log);
    });

    await isar.writeTxn(() async {
      await isar.weightLogs.putAll(logsToAdd);
    });
  }
}

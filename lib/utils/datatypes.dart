enum BodyPart {
  abs,
  back,
  biceps,
  triceps,
  shoulders,
  chest,
  glutes,
  hamstrings,
  quads,
  calves,
  forearms,
}

enum Difficulty { beginner, intermediate, advanced }

enum Rating { veryEasy, easy, neutral, hard, veryHard }

enum RepRange {
  lowRep, //0-5
  strength, //6-8
  hypertrophy, //8-12
  extendedHypertrophy, //12-15
  highRep, //15+
}

enum WorkoutStatus { planned, inProgress, completed, skipped }

class WeekSelectionResult {
  final int selectedTotalWeek;
  final DateTime startOfWeek;
  final DateTime endOfWeek;
  final DateTime? selectedDay;

  const WeekSelectionResult({
    required this.selectedTotalWeek,
    required this.startOfWeek,
    required this.endOfWeek,
    this.selectedDay,
  });
}

class PlanPersonalizationResult {
  final Map<String, int>? dayOrder;
  final DateTime selectedStartDate;
  final DateTime firstWeekStart;

  const PlanPersonalizationResult({
    this.dayOrder,
    required this.selectedStartDate,
    required this.firstWeekStart,
  });
}

class BlueprintEntry {
  final String exerciseName;
  final int sets;
  final RepRange reps;

  const BlueprintEntry({
    required this.exerciseName,
    required this.sets,
    required this.reps,
  });
}

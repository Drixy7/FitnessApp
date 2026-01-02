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

class WeekSelectionResult {
  int selectedTotalWeek;
  DateTime startOfWeek;
  DateTime endOfWeek;

  WeekSelectionResult({
    required this.selectedTotalWeek,
    required this.startOfWeek,
    required this.endOfWeek,
  });
}

class BlueprintEntry {
  String exerciseName;
  int sets;
  RepRange reps;

  BlueprintEntry({
    required this.exerciseName,
    required this.sets,
    required this.reps,
  });
}

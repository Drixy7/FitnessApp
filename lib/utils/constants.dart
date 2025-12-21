import '../models/exercise.dart';
import 'enums.dart';

List<Exercise> DefaultExercises() {
  return [
    // --- CHEST ---
    Exercise()
      ..name = "Bench Press"
      ..bodyPart = BodyPart.chest
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/barbell-bench-press",
    Exercise()
      ..name = "Incline Barbell Press"
      ..bodyPart = BodyPart.chest
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/barbell-incline-bench-press",
    Exercise()
      ..name = "Incline Dumbbell Press"
      ..bodyPart = BodyPart.chest
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/dumbbell-incline-bench-press",
    Exercise()
      ..name = "Incline Machine Press"
      ..bodyPart = BodyPart.chest
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/machine-plate-loaded-incline-chest-press",
    Exercise()
      ..name = "Machine Pec Fly"
      ..bodyPart = BodyPart.chest
      ..difficulty = Difficulty.beginner
      ..moreInformationURL = "https://musclewiki.com/exercise/machine-pec-fly",
    Exercise()
      ..name = "Cable Pec Fly"
      ..bodyPart = BodyPart.chest
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL = "https://musclewiki.com/exercise/cable-pec-fly",

    Exercise()
      ..name = "Push-ups"
      ..bodyPart = BodyPart.chest
      ..difficulty = Difficulty.beginner
      ..moreInformationURL = "https://musclewiki.com/exercise/push-up",

    // --- BACK ---
    Exercise()
      ..name = "Pull-Ups"
      ..bodyPart = BodyPart.back
      ..difficulty = Difficulty.advanced
      ..moreInformationURL = "https://musclewiki.com/exercise/pull-ups",
    Exercise()
      ..name = "Lat Pulldown"
      ..bodyPart = BodyPart.back
      ..difficulty = Difficulty.beginner
      ..moreInformationURL = "https://musclewiki.com/exercise/narrow-pulldown",
    Exercise()
      ..name = "Seated Cable Row"
      ..bodyPart = BodyPart.back
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/machine-seated-cable-row",
    Exercise()
      ..name = "Chest supported T Bar Row"
      ..bodyPart = BodyPart.back
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/machine-chest-supported-t-bar-row",
    Exercise()
      ..name = "Dumbbell Shrugs"
      ..bodyPart = BodyPart.back
      ..difficulty = Difficulty.beginner
      ..moreInformationURL = "https://musclewiki.com/exercise/dumbbell-shrug",
    Exercise()
      ..name = "Cable Shrugs"
      ..bodyPart = BodyPart.back
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/cable-30-degree-shrug",
    // --- SHOULDERS ---
    Exercise()
      ..name = "Dumbbell Shoulder Press"
      ..bodyPart = BodyPart.shoulders
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/dumbbell-seated-overhead-press",
    Exercise()
      ..name = "Machine Shoulder Press"
      ..bodyPart = BodyPart.shoulders
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/machine-overhand-overhead-press",
    Exercise()
      ..name = "Barbell Shoulder Press"
      ..bodyPart = BodyPart.shoulders
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/barbell-overhead-press",
    Exercise()
      ..name = "Dumbbell Lateral Raises"
      ..bodyPart = BodyPart.shoulders
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/dumbbell-lateral-raise",
    Exercise()
      ..name = "Machine Lateral Raises"
      ..bodyPart = BodyPart.shoulders
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/machine-standing-lateral-raise",
    Exercise()
      ..name = "Reverse fly"
      ..bodyPart = BodyPart.shoulders
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/machine-reverse-fly",
    Exercise()
      ..name = "face pulls"
      ..bodyPart = BodyPart.shoulders
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/machine-face-pulls",

    // --- BICEPS ---
    Exercise()
      ..name = "Barbell Biceps Curl"
      ..bodyPart = BodyPart.biceps
      ..difficulty = Difficulty.beginner
      ..moreInformationURL = "https://musclewiki.com/exercise/barbell-curl",
    Exercise()
      ..name = "Dumbbell Hammer Curl"
      ..bodyPart = BodyPart.biceps
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/dumbbell-hammer-curl",
    Exercise()
      ..name = "Cable Hammer Curl"
      ..bodyPart = BodyPart.biceps
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          " https://musclewiki.com/exercise/cable-rope-hammer-curl",
    Exercise()
      ..name = "Preacher Curl"
      ..bodyPart = BodyPart.biceps
      ..difficulty = Difficulty.advanced
      ..moreInformationURL =
          "https://musclewiki.com/exercise/ez-bar-preacher-curl",
    Exercise()
      ..name = "Dumbbell Spider Curl"
      ..bodyPart = BodyPart.biceps
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/dumbbell-spider-curl",
    Exercise()
      ..name = "Cable Bar Curl"
      ..bodyPart = BodyPart.biceps
      ..difficulty = Difficulty.beginner
      ..moreInformationURL = "https://musclewiki.com/exercise/cable-bar-curl",

    // --- TRICEPS ---
    Exercise()
      ..name = "Cable Rope Pushdown"
      ..bodyPart = BodyPart.triceps
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/cable-rope-pushdown",
    Exercise()
      ..name = "Cable Rope Overhead Triceps Extension"
      ..bodyPart = BodyPart.triceps
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/cable-rope-overhead-tricep-extension",
    Exercise()
      ..name = "Dips"
      ..bodyPart = BodyPart.triceps
      ..difficulty = Difficulty.advanced
      ..moreInformationURL =
          "https://musclewiki.com/exercise/plate-weighted-dip",
    Exercise()
      ..name = "Bench Dips"
      ..bodyPart = BodyPart.triceps
      ..difficulty = Difficulty.beginner
      ..moreInformationURL = "https://musclewiki.com/exercise/bench-dips",
    Exercise()
      ..name = "Dumbbell Skullcrusher"
      ..bodyPart = BodyPart.triceps
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/dumbbell-skullcrusher",
    Exercise()
      ..name = "Barbell Close Grip Bench Press"
      ..bodyPart = BodyPart.triceps
      ..difficulty = Difficulty.advanced
      ..moreInformationURL = "Barbell Close Grip Bench Press",

    // --- QUADS  ---
    Exercise()
      ..name = "Barbell Squat"
      ..bodyPart = BodyPart.quads
      ..difficulty = Difficulty.advanced
      ..moreInformationURL = "https://musclewiki.com/exercise/barbell-squat",
    Exercise()
      ..name = "Hack Squat"
      ..bodyPart = BodyPart.quads
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/machine-hack-squat",

    Exercise()
      ..name = "Leg Extensions"
      ..bodyPart = BodyPart.quads
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/machine-leg-extension",
    Exercise()
      ..name = "Leg Press"
      ..bodyPart = BodyPart.quads
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/machine-leg-press",
    Exercise()
      ..name = "Goblet Squat"
      ..bodyPart = BodyPart.quads
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/dumbbell-goblet-squat",
    Exercise()
      ..name = "Machine Hip Adduction"
      ..bodyPart = BodyPart.quads
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/machine-hip-adduction",
    Exercise()
      ..name = "Cable Hip Adduction"
      ..bodyPart = BodyPart.quads
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "    https://musclewiki.com/exercise/cable-standing-hip-adduction",
    // --- HAMSTRINGS ---
    Exercise()
      ..name = "Barbell Deadlift"
      ..bodyPart = BodyPart.hamstrings
      ..difficulty = Difficulty.advanced
      ..moreInformationURL = "https://musclewiki.com/exercise/barbell-deadlift",
    Exercise()
      ..name = "Barbell RDL"
      ..bodyPart = BodyPart.hamstrings
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/barbell-romanian-deadlift",
    Exercise()
      ..name = "Seated Leg Curl"
      ..bodyPart = BodyPart.hamstrings
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/machine-seated-leg-curl",
    Exercise()
      ..name = "Laying Leg Curl"
      ..bodyPart = BodyPart.hamstrings
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/machine-hamstring-curl",
    Exercise()
      ..name = "Barbell Good Morning"
      ..bodyPart = BodyPart.hamstrings
      ..difficulty = Difficulty.advanced
      ..moreInformationURL =
          "https://musclewiki.com/exercise/barbell-low-bar-good-morning",

    // --- GLUTES ---
    Exercise()
      ..name = "Bulgarian Split Squat"
      ..bodyPart = BodyPart.glutes
      ..difficulty = Difficulty.advanced
      ..moreInformationURL =
          "https://musclewiki.com/exercise/dumbbell-bulgarian-split-squat",
    Exercise()
      ..name = "Machine Hip Abduction"
      ..bodyPart = BodyPart.glutes
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/machine-hip-abduction",
    Exercise()
      ..name = "Cable Hip Abduction"
      ..bodyPart = BodyPart.glutes
      ..difficulty = Difficulty.advanced
      ..moreInformationURL =
          "https://musclewiki.com/exercise/cable-standing-hip-abduction",
    Exercise()
      ..name = "Barbell Hip Thrust"
      ..bodyPart = BodyPart.glutes
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/barbell-hip-thrust",
    Exercise()
      ..name = "Machine Hip Thrust"
      ..bodyPart = BodyPart.glutes
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/machine-hip-thrust",
    Exercise()
      ..name = "Cable Kickback"
      ..bodyPart = BodyPart.glutes
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/cable-standing-straight-leg-glute-glute-kickback",
    Exercise()
      ..name = "Dumbbell Step Up"
      ..bodyPart = BodyPart.glutes
      ..difficulty = Difficulty.beginner
      ..moreInformationURL = "https://musclewiki.com/exercise/dumbbell-step-up",
    Exercise()
      ..name = "Dumbbell Lunge"
      ..bodyPart = BodyPart.hamstrings
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/dumbbell-forward-lunge",
    // --- CALVES  ---
    Exercise()
      ..name = "Machine Standing Calf Raise"
      ..bodyPart = BodyPart.calves
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/machine-standing-calf-raises",
    Exercise()
      ..name = "Machine Seated Calf Raise"
      ..bodyPart = BodyPart.calves
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/machine-seated-calf-raises",
    Exercise()
      ..name = "Barbell Seated Calf Raise"
      ..bodyPart = BodyPart.calves
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/smith-machine-seated-calf-raise",
    Exercise()
      ..name = "Barbell Standing Calf Raise"
      ..bodyPart = BodyPart.calves
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/barbell-toes-up-calf-raise",
    Exercise()
      ..name = "Leg Press Calf Raise"
      ..bodyPart = BodyPart.calves
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/machine-plate-loaded-calf-raise",
    Exercise()
      ..name = "Donkey Calf Raise"
      ..bodyPart = BodyPart.calves
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/machine-donkey-calf-raise",
    // --- ABS ---
    Exercise()
      ..name = "Crunch"
      ..bodyPart = BodyPart.abs
      ..difficulty = Difficulty.beginner
      ..moreInformationURL = "https://musclewiki.com/exercise/crunches",
    Exercise()
      ..name = "Laying Leg Raise"
      ..bodyPart = BodyPart.abs
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/laying-leg-raises",
    Exercise()
      ..name = "Plank"
      ..bodyPart = BodyPart.abs
      ..difficulty = Difficulty.beginner
      ..moreInformationURL = "https://musclewiki.com/exercise/forearm-plank",
    Exercise()
      ..name = "Russian Twist"
      ..bodyPart = BodyPart.abs
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/dumbbell-russian-twist",
    Exercise()
      ..name = "Mountain Climber"
      ..bodyPart = BodyPart.abs
      ..difficulty = Difficulty.beginner
      ..moreInformationURL = "https://musclewiki.com/exercise/mountain-climber",
    Exercise()
      ..name = "Machine Crunch"
      ..bodyPart = BodyPart.abs
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL = "https://musclewiki.com/exercise/machine-crunch",
    Exercise()
      ..name = "Hanging Knee Raise"
      ..bodyPart = BodyPart.abs
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/hanging-knee-raises",
    // --- Forearms ---
    Exercise()
      ..name = "Dumbbell Wrist Curl"
      ..bodyPart = BodyPart.forearms
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/dumbbell-wrist-curl",
    Exercise()
      ..name = "Cable Wrist Curl"
      ..bodyPart = BodyPart.forearms
      ..difficulty = Difficulty.beginner
      ..moreInformationURL = "https://musclewiki.com/exercise/cable-wrist-curl",
    Exercise()
      ..name = "Barbell Wrist Curl"
      ..bodyPart = BodyPart.forearms
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/barbell-wrist-curl",
    Exercise()
      ..name = "Dumbbell Farmer Walk "
      ..bodyPart = BodyPart.forearms
      ..difficulty = Difficulty.beginner
      ..moreInformationURL =
          "https://musclewiki.com/exercise/dumbbell-farmer-walk",
    Exercise()
      ..name = "Reverse Cable Bar Curl"
      ..bodyPart = BodyPart.forearms
      ..difficulty = Difficulty.intermediate
      ..moreInformationURL =
          "https://musclewiki.com/exercise/cable-bar-reverse-grip-curl",
    Exercise()
      ..name = "Barbell Reverse Curl"
      ..bodyPart = BodyPart.forearms
      ..difficulty = Difficulty.advanced
      ..moreInformationURL =
          "https://musclewiki.com/exercise/barbell-reverse-curl",
  ];
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

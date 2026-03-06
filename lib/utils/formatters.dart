int weekFromAbsoluteWeek(int selectedWeek, int weeksPerCycle) =>
    ((selectedWeek - 1) % weeksPerCycle) + 1;

int cycleFromAbsoluteWeek(int selectedWeek, int weeksPerCycle) =>
    ((selectedWeek - 1) ~/ weeksPerCycle) + 1;

String formatTime(int timeInSeconds) {
  final d = Duration(seconds: timeInSeconds);
  String fmt(int n) => n.toString().padLeft(2, '0');

  if (d.inHours > 0) {
    return "${fmt(d.inHours)}:${fmt(d.inMinutes.remainder(60))}:${fmt(d.inSeconds.remainder(60))}";
  } else {
    return "${fmt(d.inMinutes.remainder(60))}:${fmt(d.inSeconds.remainder(60))}";
  }
}

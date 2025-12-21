int weekFromAbsoluteWeek(int selectedWeek, int weeksPerCycle) =>
    ((selectedWeek - 1) % weeksPerCycle) + 1;

int cycleFromAbsoluteWeek(int selectedWeek, int weeksPerCycle) =>
    ((selectedWeek - 1) ~/ weeksPerCycle) + 1;

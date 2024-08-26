class HabitEntity {
  final String id;
  final String name;
  final String icon;
  final String color;
  final List<String> days;
  final String repeatMode;
  final int timer;
  final List<DateTime> doneDates;
  final List<DateTime> missedDates;
  final String goal;
  final int streak;
  final List<String> reminders;
  final int repeatPerDay;
  final DateTime endDate;
  final int endByDays;
  final List<String> trackingData;
  final String category;
  final bool isPaused;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool hasEnd;
  final String description;

  const HabitEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.days,
    required this.repeatMode,
    required this.timer,
    required this.doneDates,
    required this.missedDates,
    required this.goal,
    required this.streak,
    required this.reminders,
    required this.repeatPerDay,
    required this.endDate,
    required this.endByDays,
    required this.trackingData,
    required this.category,
    required this.isPaused,
    required this.createdAt,
    required this.updatedAt,
    required this.hasEnd,
    required this.description,
  });
}

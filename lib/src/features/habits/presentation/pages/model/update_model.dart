class HabitUpdateModel {
  String id;
  String name;
  String icon;
  String color;
  List<String> days;
  String repeatMode;
  int timer;
  List<DateTime> doneDates;
  List<DateTime> missedDates;
  String goal;
  int streak;
  List<String> reminders;
  int repeatPerDay;
  DateTime endDate;
  int endByDays;
  List<String> trackingData;
  String category;
  bool isPaused;
  DateTime createdAt;
  DateTime updatedAt;
  bool hasEnd;
  String description;

  HabitUpdateModel({
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
  static final emptyHabitData = HabitUpdateModel(
    id: "",
    name: "",
    icon: "",
    color: "",
    days: [],
    repeatMode: "",
    timer: 0,
    doneDates: [],
    missedDates: [],
    goal: "",
    streak: 0,
    reminders: [],
    repeatPerDay: 1,
    endDate: DateTime.utc(2030),
    endByDays: 0,
    trackingData: [],
    category: "",
    isPaused: false,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    hasEnd: false,
    description: "",
  );
}

import 'package:plant_application/models/timing_enum.dart';

String dateTimeToDateString(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

DateTime dateStringToDateTime(String dateString) {
  return DateTime.parse(dateString);
}

Timing? stringToTiming(String? timing) {
  if (timing == null) return null;

  switch (timing) {
    case "early":
      return Timing.early;
    case "just right":
      return Timing.justRight;
    case "late":
      return Timing.late;
    case "not sure":
      return Timing.notSure;
    default:
      return null;
  }
}

String? timingToString(Timing? timing) {
  if (timing == null) return null;

  switch (timing) {
    case Timing.early:
      return "early";
    case Timing.justRight:
      return "just right";
    case Timing.late:
      return "late";
    case Timing.notSure:
      return "not sure";
  }
}

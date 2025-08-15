import 'package:plant_application/screens/add_watering/watering_form_data.dart';

class WaterEventData {
  final int id;
  final int plantId;
  final DateTime date;
  final String? notes;
  final int? daysSinceLast;
  final Timing? timingFeedback;
  final int? offsetDays;

  WaterEventData({
    required this.id,
    required this.plantId,
    required this.date,
    this.notes,
    this.daysSinceLast,
    this.timingFeedback,
    this.offsetDays,
  });

  WaterEventData copyWith({int? daysSinceLast}) => WaterEventData(
    id: id,
    plantId: plantId,
    date: date,
    notes: notes,
    timingFeedback: timingFeedback,
    offsetDays: offsetDays,
    daysSinceLast: daysSinceLast ?? this.daysSinceLast,
  );
}

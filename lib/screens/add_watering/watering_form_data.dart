import 'package:drift/drift.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/enums/event_types_enum.dart';
import 'package:plant_application/models/fertilizer_data.dart';
import 'package:plant_application/models/enums/timing_enum.dart';
import 'package:plant_application/utils/datetime_extensions.dart';

class WateringFormData {
  final int plantId;
  final DateTime date;
  final int? waterTypeId;
  final Timing timing;
  final int daysToCorrect;
  final Set<FertilizerData> fertilizers;
  final double potSize;
  final String soilType;
  final String notes;
  final String repotNotes;
  final bool isRepot;
  final bool isEdit;
  final int? eventId;

  WateringFormData({
    required this.plantId,
    DateTime? date,
    this.waterTypeId,
    this.timing = Timing.justRight,
    this.daysToCorrect = 0,
    Set<FertilizerData>? fertilizers,
    this.potSize = 6.0,
    this.soilType = '',
    this.notes = '',
    this.repotNotes = '',
    this.isRepot = false,
    this.isEdit = false,
    this.eventId,
  }) : fertilizers = fertilizers ?? {},
       date = date ?? DateTime.now();

  WateringFormData.forEdit({
    required this.plantId,
    DateTime? date,
    this.waterTypeId,
    this.timing = Timing.justRight,
    this.daysToCorrect = 0,
    Set<FertilizerData>? fertilizers,
    this.potSize = 6,
    this.soilType = '',
    this.notes = '',
    this.repotNotes = '',
    this.isRepot = false,
    required this.eventId,
  }) : fertilizers = fertilizers ?? {},
       date = date ?? DateTime.now(),
       isEdit = true;

  static const _unset = Object();

  WateringFormData copyWith({
    Object? waterTypeId = _unset,
    DateTime? date,
    Timing? timing,
    int? daysToCorrect,
    Set<FertilizerData>? fertilizers,
    double? potSize,
    String? soilType,
    String? notes,
    String? repotNotes,
    bool? isRepot,
  }) {
    return WateringFormData(
      plantId: plantId,
      date: date ?? this.date,
      waterTypeId:
          waterTypeId == _unset
              ? this.waterTypeId
              : (waterTypeId == null)
              ? null
              : waterTypeId as int,
      timing: timing ?? this.timing,
      daysToCorrect: daysToCorrect ?? this.daysToCorrect,
      fertilizers: fertilizers ?? this.fertilizers,
      potSize: potSize ?? this.potSize,
      soilType: soilType ?? this.soilType,
      notes: notes ?? this.notes,
      repotNotes: repotNotes ?? this.repotNotes,
      isRepot: isRepot ?? this.isRepot,
      isEdit: isEdit,
      eventId: eventId,
    );
  }

  EventsCompanion toWateringEventCompanion() {
    return EventsCompanion(
      plantId: Value(plantId),
      eventType: Value(EventType.watering.toString()),
      date: Value(date.dateTimeToDateString()),
      notes: (notes.isEmpty) ? Value.absent() : Value(notes),
    );
  }

  WaterEventsCompanion toEventsCompanionWater(int eventId) {
    return WaterEventsCompanion(
      eventId: Value(eventId),
      timingFeedback: Value(timing.timingToString()),
      offsetDays: Value(daysToCorrect.abs()),
    );
  }

  EventsCompanion toEventCompanionRepot() {
    return EventsCompanion(
      plantId: Value(plantId),
      eventType: Value(EventType.repot.toString()),
      date: Value(date.dateTimeToDateString()),
      notes: (repotNotes.isEmpty) ? Value.absent() : Value(repotNotes),
    );
  }

  RepotEventsCompanion toRepotEventCompanion(int eventId) {
    return RepotEventsCompanion(
      eventId: Value(eventId),
      potSize: Value(potSize),
      soilType: Value(soilType),
    );
  }

  List<EventAccessoriesCompanion> toEventAccessoriesCompanionList(int eventId) {
    final List<EventAccessoriesCompanion> list = [];
    list.add(
      EventAccessoriesCompanion(
        eventId: Value(eventId),
        accessoryId:
            (waterTypeId is int) ? Value(waterTypeId as int) : Value.absent(),
      ),
    );
    for (final fert in fertilizers) {
      list.add(
        EventAccessoriesCompanion(
          eventId: Value(eventId),
          accessoryId: Value(fert.accessoryId),
          strength: Value(fert.strength),
        ),
      );
    }
    return list;
  }
}

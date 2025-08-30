import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/water_event_data.dart';
import 'package:plant_application/notifier_providers/db_providers.dart';
import 'package:plant_application/utils/adaptive_watering_schedule.dart';
import 'package:plant_application/utils/datetime_extensions.dart';

enum WateringStatus { green, yellow, red, white }

class PlantCardData {
  final Plant plant;
  final DateTime? lastWatered;
  final DateTime? earliestNextWater;
  final DateTime? latestNextWater;
  final AdaptiveWateringSchedule? schedule;
  final WateringStatus? wateringStatus;

  PlantCardData({
    required this.plant,
    this.lastWatered,
    this.earliestNextWater,
    this.latestNextWater,
    this.schedule,
    this.wateringStatus,
  });

  static PlantCardData buildPlantCardData(
    Plant plant,
    List<WaterEventData> events,
  ) {
    AdaptiveWateringSchedule? schedule;

    if (plant.inWateringSchedule &&
        plant.minWateringDays != null &&
        plant.maxWateringDays != null) {
      schedule = AdaptiveWateringSchedule(
        minSuccessfulDays: plant.minWateringDays!,
        maxSuccessfulDays: plant.maxWateringDays!,
        totalFeedback: plant.totalFeedback,
        positiveFeedback: plant.positiveFeedback,
      );
    }

    final lastWatered = events.isNotEmpty ? events.first : null;

    if (!plant.inWateringSchedule) {
      return PlantCardData(
        plant: plant,
        lastWatered: lastWatered?.date,
        earliestNextWater: null,
        latestNextWater: null,
        schedule: schedule,
        wateringStatus: WateringStatus.white,
      );
    }

    final lastWateredDate =
        (lastWatered != null)
            ? lastWatered.date
            : DateTimeHelpers.dateStringToDateTime(plant.dateAdded);

    DateTime? minDueDate;
    DateTime? maxDueDate;

    if (schedule != null) {
      minDueDate = lastWateredDate.add(
        Duration(days: schedule.minSuccessfulDays.round()),
      );
      maxDueDate = lastWateredDate.add(
        Duration(days: schedule.maxSuccessfulDays.round()),
      );
    }

    final now = DateTime.now();
    final nowDate = DateTime(now.year, now.month, now.day);

    late final WateringStatus status;
    if (minDueDate == null || maxDueDate == null) {
      status = WateringStatus.white;
    } else if (nowDate.isBefore(minDueDate)) {
      status = WateringStatus.green;
    } else if (nowDate.isAfter(maxDueDate)) {
      status = WateringStatus.red;
    } else {
      status = WateringStatus.yellow;
    }

    return PlantCardData(
      plant: plant,
      lastWatered: lastWateredDate,
      earliestNextWater: minDueDate,
      latestNextWater: maxDueDate,
      schedule: schedule,
      wateringStatus: status,
    );
  }

  String daysUntilDueStatus() {
    if (!plant.inWateringSchedule) {
      return "not in watering schedule";
    }
    if (schedule == null) {
      return "no watering frequency recorded";
    }

    final lastWateredDate =
        (lastWatered != null)
            ? lastWatered!
            : DateTimeHelpers.dateStringToDateTime(plant.dateAdded);
    final dueDate = lastWateredDate.add(
      Duration(days: schedule!.minSuccessfulDays.round()),
    );
    final endDate = lastWateredDate.add(
      Duration(days: schedule!.maxSuccessfulDays.round()),
    );
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (today.isBefore(dueDate)) {
      final days = dueDate.difference(today).inDays;
      return "due in $days day${days != 1 ? 's' : ''}";
    } else if (today.isAfter(endDate)) {
      final days = today.difference(endDate).inDays;
      return "overdue by $days day${days != 1 ? 's' : ''}";
    } else {
      return "within window";
    }
  }
}

final plantCardsProvider = FutureProvider<List<PlantCardData>>((ref) async {
  final plants = await ref.watch(allPlantsProvider.future);
  final wateringEvents = await ref.watch(allWateringEventsProvider.future);

  return plants.map((plant) {
    final events = wateringEvents[plant.id] ?? [];
    return PlantCardData.buildPlantCardData(plant, events);
  }).toList();
});

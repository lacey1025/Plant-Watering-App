import 'package:plant_application/database/converters.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/water_event_data.dart';
import 'package:plant_application/utils/adaptive_watering_schedule.dart';

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
            : dateStringToDateTime(plant.dateAdded);

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
      return "Not in watering schedule";
    }
    if (schedule == null) {
      return "No watering frequency recorded";
    }

    final lastWateredDate =
        (lastWatered != null)
            ? lastWatered!
            : dateStringToDateTime(plant.dateAdded);
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
      return "Within window in $days day${days != 1 ? 's' : ''}";
    } else if (today.isAfter(endDate)) {
      final days = today.difference(endDate).inDays;
      return "Overdue by $days day${days != 1 ? 's' : ''}";
    } else {
      return "Within watering window";
    }
  }
}

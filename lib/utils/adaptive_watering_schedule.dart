import 'dart:math';
import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/plant_card_data.dart';
import 'package:plant_application/models/water_event_data.dart';
import 'package:plant_application/providers/db_provider.dart';
import 'package:plant_application/providers/home_screen_providers.dart';
import 'package:plant_application/screens/add_watering/watering_form_data.dart';

class AdaptiveWateringSchedule {
  double minSuccessfulDays;
  double maxSuccessfulDays;
  int totalFeedback; // Total feedback events
  int positiveFeedback; // "Just right" feedback count

  int get frequency => (minSuccessfulDays + maxSuccessfulDays) ~/ 2;
  // int get windowSize => max(1, (maxSuccessfulDays - minSuccessfulDays) ~/ 2);
  double get confidence => positiveFeedback / max(1, totalFeedback);

  AdaptiveWateringSchedule({
    required this.minSuccessfulDays,
    required this.maxSuccessfulDays,
    required this.totalFeedback,
    required this.positiveFeedback,
  });

  void updateSchedule(int actualDays, Timing feedback, int offsetDays) {
    totalFeedback++;

    double learningRate =
        1.0 / sqrt(totalFeedback); // Learn less as we get more data

    switch (feedback) {
      case Timing.justRight:
        positiveFeedback++;
        // Gently adjust bounds toward this successful timing
        minSuccessfulDays =
            lerpDouble(minSuccessfulDays, actualDays * 0.95, learningRate)!;
        maxSuccessfulDays =
            lerpDouble(maxSuccessfulDays, actualDays * 1.05, learningRate)!;
        break;

      case Timing.early:
        // Don't change min (plant didn't need it yet), but max could be higher
        maxSuccessfulDays =
            lerpDouble(
              maxSuccessfulDays,
              actualDays + offsetDays,
              learningRate * 0.5,
            )!;
        break;

      case Timing.late:
        // Plant needed it sooner - important signal
        minSuccessfulDays =
            lerpDouble(
              minSuccessfulDays,
              actualDays - offsetDays,
              learningRate,
            )!;
        // Also adjust max down slightly
        maxSuccessfulDays =
            lerpDouble(maxSuccessfulDays, actualDays, learningRate * 0.3)!;
        break;
    }
  }

  // Reverts the schedule by undoing the most recent feedback update
  void revertLastUpdate(double actualDays, Timing feedback, int offsetDays) {
    if (totalFeedback == 0) return; // Nothing to revert

    totalFeedback--;
    double learningRate =
        1.0 / sqrt(totalFeedback + 1); // Original learning rate

    switch (feedback) {
      case Timing.justRight:
        positiveFeedback--;
        // Reverse the lerp adjustments
        double targetMin = actualDays * 0.95;
        double targetMax = actualDays * 1.05;
        minSuccessfulDays = _reverseLerp(
          minSuccessfulDays,
          targetMin,
          learningRate,
        );
        maxSuccessfulDays = _reverseLerp(
          maxSuccessfulDays,
          targetMax,
          learningRate,
        );
        break;

      case Timing.early:
        double targetMax = actualDays + offsetDays;
        maxSuccessfulDays = _reverseLerp(
          maxSuccessfulDays,
          targetMax,
          learningRate * 0.5,
        );
        break;

      case Timing.late:
        double targetMin = actualDays - offsetDays;
        double targetMax = actualDays;
        minSuccessfulDays = _reverseLerp(
          minSuccessfulDays,
          targetMin,
          learningRate,
        );
        maxSuccessfulDays = _reverseLerp(
          maxSuccessfulDays,
          targetMax,
          learningRate * 0.3,
        );
        break;
    }
  }

  /// Recalculates the entire schedule from scratch using a list of events
  void recalculateSchedule(
    List<WaterEventData> events,
    double initialMinDays,
    double initialMaxDays,
  ) {
    // Reset to initial state
    minSuccessfulDays = initialMinDays;
    maxSuccessfulDays = initialMaxDays;
    totalFeedback = 0;
    positiveFeedback = 0;

    // Replay all events in chronological order
    for (int i = 0; i < events.length; i++) {
      final event = events[i];

      if (event.timingFeedback != null && event.offsetDays != null) {
        // Calculate actual days since last watering
        int actualDays;
        if (i == 0) {
          // First event - use some default or calculate from plant creation
          actualDays = 7; // You might want to pass this as a parameter
        } else {
          final previousEvent = events[i - 1];
          actualDays = event.date.difference(previousEvent.date).inDays;
        }

        updateSchedule(actualDays, event.timingFeedback!, event.offsetDays!);
      }
    }
  }

  static Future<void> adjustPlantSchedule(
    int eventId,
    PlantCardData plant,
    Ref ref,
  ) async {
    final db = ref.read(databaseProvider);
    final events = await ref.read(
      wateringEventsForPlantProvider(plant.plant.id).future,
    );
    if (!plant.plant.inWateringSchedule ||
        plant.plant.minWateringDays == null ||
        plant.plant.maxWateringDays == null) {
      return;
    }
    late AdaptiveWateringSchedule schedule;
    if (plant.schedule == null) {
      schedule = AdaptiveWateringSchedule(
        minSuccessfulDays: plant.plant.minWateringDays!.toDouble(),
        maxSuccessfulDays: plant.plant.maxWateringDays!.toDouble(),
        totalFeedback: 0,
        positiveFeedback: 0,
      );
    } else {
      schedule = plant.schedule!;
    }

    schedule.recalculateSchedule(
      events,
      plant.plant.minWateringDays!.toDouble(),
      plant.plant.maxWateringDays!.toDouble(),
    );

    await db.plantsDao.updatePlantFromCompanion(
      plant.plant.id,
      PlantsCompanion(
        minWateringDays: Value(schedule.minSuccessfulDays),
        maxWateringDays: Value(schedule.maxSuccessfulDays),
        totalFeedback: Value(schedule.totalFeedback),
        positiveFeedback: Value(schedule.positiveFeedback),
      ),
    );
  }

  /// Helper method to reverse a lerp operation
  double _reverseLerp(double current, double target, double t) {
    if (t == 0) return current;
    return (current - target * t) / (1 - t);
  }
}

import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/plant_card_data.dart';
import 'package:plant_application/models/timing_enum.dart';
import 'package:plant_application/providers/db_provider.dart';
import 'package:plant_application/utils/datetime_extensions.dart';

class PlantNotifier extends StateNotifier<AsyncValue<PlantCardData?>> {
  PlantNotifier(this.ref, this.plantId) : super(const AsyncValue.loading()) {
    _listenToDb();
  }

  final Ref ref;
  final int plantId;

  StreamSubscription? _plantSubscription;
  StreamSubscription? _eventsSubscription;

  void _listenToDb() {
    final db = ref.read(databaseProvider);
    _plantSubscription = db.plantsDao
        .watchPlantById(plantId)
        .listen(
          (plant) {
            if (plant == null) {
              state = const AsyncValue.data(null);
              _eventsSubscription?.cancel();
              return;
            }
            _eventsSubscription?.cancel();

            _eventsSubscription = db.eventsDao
                .watchWateringEventsForPlant(plantId)
                .listen(
                  (events) {
                    try {
                      final cardData = PlantCardData.buildPlantCardData(
                        plant,
                        events,
                      );
                      state = AsyncValue.data(cardData);
                    } catch (e, st) {
                      state = AsyncValue.error(e, st);
                    }
                  },
                  onError: (err, st) {
                    state = AsyncValue.error(err, st);
                  },
                );
          },
          onError: (err, st) {
            state = AsyncValue.error(err, st);
          },
        );
  }

  @override
  void dispose() {
    _plantSubscription?.cancel();
    _eventsSubscription?.cancel();
    super.dispose();
  }

  Future<void> deletePlant() async {
    final current = state.value;
    if (current == null) return;
    final db = ref.read(databaseProvider);
    final events = await db.eventsDao.getEventIdsByPlantId(plantId);

    await db.transaction(() async {
      await db.accessoriesDao.deleteEventAccessoriesByEvents(events);
      await db.eventsDao.deleteRepotEvents(events);
      await db.eventsDao.deleteWaterEvents(events);
      await db.eventsDao.deleteEventsByPlantId(plantId);
      await db.photosDao.deletePhotosByPlantId(plantId);
      await db.plantsDao.deletePlant(plantId);
    });
  }

  Future<void> updateFrequency(
    DateTime wateredDate,
    Timing? timing,
    int? offsetDays,
  ) async {
    final plant = state.value;

    if (plant == null || plant.schedule == null) {
      return;
    }
    final schedule = plant.schedule!;
    final lastWatering = plant.lastWatered;
    final daysSinceLast =
        wateredDate
            .difference(
              lastWatering ??
                  DateTimeHelpers.dateStringToDateTime(plant.plant.dateAdded),
            )
            .inDays;
    if (timing != null) {
      schedule.updateSchedule(daysSinceLast, timing, offsetDays ?? 0);
    }

    final db = ref.read(databaseProvider);
    db.plantsDao.updatePlantFromCompanion(
      plantId,
      PlantsCompanion(
        // wateringFrequency: Value(schedule.frequency),
        minWateringDays: Value(schedule.minSuccessfulDays),
        maxWateringDays: Value(schedule.maxSuccessfulDays),
        totalFeedback: Value(schedule.totalFeedback),
        positiveFeedback: Value(schedule.positiveFeedback),
      ),
    );
  }

  Future<void> updatePlant(Plant updatedPlant) async {
    final db = ref.read(databaseProvider);
    await db.plantsDao.updatePlant(updatedPlant);
  }
}

final plantNotifierProvider = StateNotifierProvider.family<
  PlantNotifier,
  AsyncValue<PlantCardData?>,
  int
>((ref, plantId) => PlantNotifier(ref, plantId));

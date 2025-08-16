import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/database/converters.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/providers/db_provider.dart';
import 'package:plant_application/providers/plant_provider.dart';
import 'package:plant_application/screens/add_watering/watering_form_data.dart';
import 'package:plant_application/utils/adaptive_watering_schedule.dart';

class WateringFormNotifier extends StateNotifier<WateringFormData> {
  final Ref ref;
  final int plantId;

  WateringFormNotifier(this.ref, this.plantId)
    : super(WateringFormData(plantId: plantId));

  void loadForEdit(WateringFormData existingData) {
    state = existingData;
  }

  void updateDate(DateTime value) {
    state = state.copyWith(date: value);
  }

  void updateWaterTypeId(int waterTypeId) {
    state = state.copyWith(waterTypeId: waterTypeId);
  }

  void removeWaterType(int waterTypeId) {
    if (state.waterTypeId == waterTypeId) {
      state = state.copyWith(waterTypeId: null);
    }
  }

  void updateTiming(Timing timing) {
    state = state.copyWith(timing: timing, daysToCorrect: 0);
  }

  void updateDaysToCorrect(int days) {
    state = state.copyWith(daysToCorrect: days);
  }

  void addFertilizer(int fertilizerId, double strength) {
    state.fertilizers.add(
      FertilizerData(accessoryId: fertilizerId, strength: strength),
    );
    state = state.copyWith(fertilizers: {...state.fertilizers});
  }

  void removeFertilizer(int fertilizerId) {
    state.fertilizers.removeWhere((f) => f.accessoryId == fertilizerId);
    state = state.copyWith(fertilizers: {...state.fertilizers});
  }

  void updateFertilizerStrength(int fertilizerId, double strength) {
    final matches = state.fertilizers.where(
      (f) => f.accessoryId == fertilizerId,
    );
    if (matches.isEmpty) return;

    final fert = matches.first;
    fert.strength = strength;

    state = state.copyWith(fertilizers: {...state.fertilizers});
  }

  void updatePotSize(int potSize) {
    state = state.copyWith(potSize: potSize);
  }

  void updateSoilType(String soildType) {
    state = state.copyWith(soilType: soildType);
  }

  void updateNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  void updateRepotNotes(String notes) {
    state = state.copyWith(repotNotes: notes);
  }

  void updateIsRepot(bool isRepot) {
    state = state.copyWith(isRepot: isRepot);
  }

  Future<void> submitForm() async {
    if (state.isEdit) {
      await submitEdit();
      return;
    }
    late int wateringEventId;
    try {
      final db = ref.watch(databaseProvider);
      final wateringEventCompanion = state.toWateringEventCompanion();

      await db.transaction(() async {
        wateringEventId = await db.eventsDao.insertEvent(
          wateringEventCompanion,
        );
        final waterCompanion = state.toEventsCompanionWater(wateringEventId);
        await db.eventsDao.insertWaterEvent(waterCompanion);
        final eventAccessories = state.toEventAccessoriesCompanionList(
          wateringEventId,
        );
        await db.accessoriesDao.insertEventAccessories(eventAccessories);
        if (state.isRepot) {
          final repotEventCompanion = state.toEventCompanionRepot();
          final eventIdRepot = await db.eventsDao.insertEvent(
            repotEventCompanion,
          );
          final repotCompanion = state.toRepotEventCompanion(eventIdRepot);
          await db.eventsDao.insertRepotEvent(repotCompanion);
        }
      });
      await _updateFrequency(wateringEventId);
    } catch (error) {
      print(error);
    }
  }

  Future<void> submitEdit() async {
    if (state.eventId == null) return;
    try {
      final db = ref.watch(databaseProvider);
      final wateringEventCompanion = EventsCompanion(
        date: Value(dateTimeToDateString(state.date)),
        notes: Value(state.notes),
      );

      await db.transaction(() async {
        await db.eventsDao.updateEventFromCompanion(
          state.eventId!,
          wateringEventCompanion,
        );
        final waterCompanion = WaterEventsCompanion(
          timingFeedback: Value(timingToString(state.timing)),
          offsetDays: Value(state.daysToCorrect),
        );
        await db.eventsDao.updateWaterEventFromCompanion(
          state.eventId!,
          waterCompanion,
        );
        final eventAccessories = state.toEventAccessoriesCompanionList(
          state.eventId!,
        );
        await db.accessoriesDao.deleteEventAccessoriesByEvents([
          state.eventId!,
        ]);
        await db.accessoriesDao.insertEventAccessories(eventAccessories);
      });
    } catch (error) {
      print(error);
    }
    final plantAsync = ref.watch(plantNotifierProvider(plantId));
    if (!plantAsync.hasValue || plantAsync.value == null) {
      return;
    }

    final plant = plantAsync.value;
    if (plant == null) return;
    await AdaptiveWateringSchedule.adjustPlantSchedule(
      state.eventId!,
      plant,
      ref,
    );
  }

  Future<void> _updateFrequency(int eventId) async {
    final plantAsync = ref.watch(plantNotifierProvider(plantId));
    if (!plantAsync.hasValue || plantAsync.value == null) {
      return; // or handle loading/error states as needed
    }

    final plant = plantAsync.value;
    if (plant == null ||
        !plant.plant.inWateringSchedule ||
        plant.plant.minWateringDays == null ||
        plant.plant.maxWateringDays == null) {
      return;
    }
    final lastWateredDate =
        plant.lastWatered ?? dateStringToDateTime(plant.plant.dateAdded);

    if (lastWateredDate.isAfter(state.date)) {
      await AdaptiveWateringSchedule.adjustPlantSchedule(eventId, plant, ref);
      return;
    }
    final daysSinceLast = state.date.difference(lastWateredDate).inDays;

    late AdaptiveWateringSchedule schedule;
    if (plant.schedule == null) {
      schedule = AdaptiveWateringSchedule(
        minSuccessfulDays: plant.plant.minWateringDays!,
        maxSuccessfulDays: plant.plant.maxWateringDays!,
        totalFeedback: plant.plant.totalFeedback,
        positiveFeedback: plant.plant.positiveFeedback,
      );
    } else {
      schedule = plant.schedule!;
    }
    schedule.updateSchedule(
      daysSinceLast,
      state.timing,
      state.daysToCorrect.abs(),
    );
    final db = ref.read(databaseProvider);
    await db.plantsDao.updatePlantFromCompanion(
      plantId,
      PlantsCompanion(
        minWateringDays: Value(schedule.minSuccessfulDays),
        maxWateringDays: Value(schedule.maxSuccessfulDays),
        totalFeedback: Value(schedule.totalFeedback),
        positiveFeedback: Value(schedule.positiveFeedback),
      ),
    );
  }

  // Future<void> deleteEvent(int eventId, PlantCardData plant) async {
  //   final db = ref.read(databaseProvider);
  //   db.eventsDao.deleteWaterEvents([eventId]);
  //   db.eventsDao.deleteEvent(eventId);

  //   final events = await ref.read(
  //     wateringEventsForPlantProvider(plant.plant.id).future,
  //   );
  //   if (!plant.plant.inWateringSchedule ||
  //       plant.plant.minWateringDays == null ||
  //       plant.plant.maxWateringDays == null) {
  //     return;
  //   }
  //   late AdaptiveWateringSchedule schedule;
  //   if (plant.schedule == null) {
  //     schedule = AdaptiveWateringSchedule(
  //       minSuccessfulDays: plant.plant.minWateringDays!.toDouble(),
  //       maxSuccessfulDays: plant.plant.maxWateringDays!.toDouble(),
  //       totalFeedback: 0,
  //       positiveFeedback: 0,
  //     );
  //   } else {
  //     schedule = plant.schedule!;
  //   }

  //   schedule.recalculateSchedule(
  //     events,
  //     plant.plant.minWateringDays!.toDouble(),
  //     plant.plant.maxWateringDays!.toDouble(),
  //   );

  //   await db.plantsDao.updatePlantFromCompanion(
  //     plantId,
  //     PlantsCompanion(
  //       minWateringDays: Value(schedule.minSuccessfulDays),
  //       maxWateringDays: Value(schedule.maxSuccessfulDays),
  //       totalFeedback: Value(schedule.totalFeedback),
  //       positiveFeedback: Value(schedule.positiveFeedback),
  //     ),
  //   );
  // }
}

final wateringFormProvider = StateNotifierProvider.family
    .autoDispose<WateringFormNotifier, WateringFormData, int>(
      (ref, plantId) => WateringFormNotifier(ref, plantId),
    );

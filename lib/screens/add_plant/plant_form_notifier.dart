import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/enums/event_types_enum.dart';
import 'package:plant_application/notifier_providers/db_providers.dart';
import 'package:plant_application/notifier_providers/photos_provider.dart';
import 'package:plant_application/screens/add_plant/plant_form_data.dart';
import 'package:plant_application/utils/datetime_extensions.dart';

class PlantFormNotifier extends StateNotifier<PlantFormData> {
  final Ref ref;
  double? initialFrequency;

  PlantFormNotifier(this.ref, PlantFormData? initialData)
    : super(initialData ?? PlantFormData()) {
    if (initialData != null) {
      initialFrequency = initialData.frequency;
    }
  }

  void updateName(String value) {
    state = state.copyWith(name: value);
  }

  void updateWateringSchedule(bool value) {
    state = state.copyWith(inSchedule: value);
  }

  void updateWateringFrequency(double value) {
    state = state.copyWith(frequency: value);
  }

  void updateNotes(String value) {
    state = state.copyWith(notes: value);
  }

  void updatePickedImage(XFile? value) {
    state = state.copyWith(pickedImage: value);
  }

  void updateLastWatered(DateTime? value) {
    state = state.copyWith(lastWatered: value);
  }

  void updatePhotoNotes(String value) {
    state = state.copyWith(photoNotes: value);
  }

  void updatePhotoDate(DateTime value) {
    state = state.copyWith(photoDate: value);
  }

  Future<void> submit() async {
    final db = ref.read(databaseProvider);
    final plant = state.toPlantCompanion();

    final stateLastWatered = state.lastWatered;
    DateTime? lastWatered;
    if (stateLastWatered != null) {
      lastWatered = DateTime(
        stateLastWatered.year,
        stateLastWatered.month,
        stateLastWatered.day,
      );
    }
    int? plantId;

    await db.transaction(() async {
      plantId = await db.plantsDao.insertPlant(plant);

      if (lastWatered != null && plantId != null) {
        await insertWateringEvent(plantId: plantId!, date: lastWatered);
      }
    });

    if (plantId != null && state.pickedImage != null) {
      await addPhoto(plantId!);
    }
  }

  Future<void> addPhoto(int plantId) async {
    final photoNotifier = ref.read(photoNotifierProvider(plantId).notifier);
    String? savedImage;
    savedImage = await photoNotifier.savePhoto(state.pickedImage!);
    if (savedImage != null) {
      final photoCompanion = state.toPhotoCompanion(plantId, savedImage);
      await photoNotifier.insertPhoto(photoCompanion);
    }
  }

  Future<void> updatePlant() async {
    final db = ref.read(databaseProvider);
    late PlantsCompanion updatedPlant;
    if (initialFrequency != null && initialFrequency != state.frequency) {
      updatedPlant = state.toPlantCompanion();
    } else {
      updatedPlant = state.toUpdateCompanion();
    }
    final id = state.id;
    if (id == null) return;

    await db.plantsDao.updatePlantFromCompanion(id, updatedPlant);
    if (state.pickedImage != null) {
      addPhoto(id);
    }
  }

  Future<void> insertWateringEvent({
    required int plantId,
    required DateTime date,
  }) async {
    final db = ref.read(databaseProvider);
    final id = await db.eventsDao.insertEvent(
      EventsCompanion(
        plantId: Value(plantId),
        eventType: Value(EventType.watering.toString()),
        date: Value(date.dateTimeToDateString()),
      ),
    );
    await db.eventsDao.insertWaterEvent(
      WaterEventsCompanion(eventId: Value(id)),
    );
  }
}

final plantFormProvider = StateNotifierProvider.autoDispose
    .family<PlantFormNotifier, PlantFormData, PlantFormData?>((
      ref,
      initialData,
    ) {
      return PlantFormNotifier(ref, initialData);
    });

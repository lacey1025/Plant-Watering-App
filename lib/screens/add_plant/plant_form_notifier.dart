import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_application/database/converters.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/providers/db_provider.dart';
import 'package:plant_application/providers/photos_provider.dart';
import 'package:plant_application/screens/add_plant/plant_form_data.dart';

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

  Future<void> submit() async {
    final db = ref.read(databaseProvider);
    final plant = state.toPlantCompanion();

    DateTime? lastWatered;
    if (state.lastWatered != null) {
      lastWatered = DateTime(
        state.lastWatered!.year,
        state.lastWatered!.month,
        state.lastWatered!.day,
      );
    }
    int? plantId;

    await db.transaction(() async {
      plantId = await db.plantsDao.insertPlant(plant);

      if (lastWatered != null && plantId != null) {
        await insertWateringEvent(plantId: plantId!, date: lastWatered);
      }
    });

    if (plantId == null) return;
    final photoNotifier = ref.read(photoNotifierProvider(plantId!).notifier);
    String? savedImage;
    if (state.pickedImage != null) {
      savedImage = await photoNotifier.savePhoto(state.pickedImage!);
    }
    if (savedImage != null) {
      await photoNotifier.insertPhoto(plantId: plantId!, photoPath: savedImage);
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

    final photoNotifier = ref.read(photoNotifierProvider(state.id!).notifier);
    String? savedImage;
    if (state.pickedImage != null) {
      savedImage = await photoNotifier.savePhoto(state.pickedImage!);
    }

    await db.transaction(() async {
      await db.plantsDao.updatePlantFromCompanion(id, updatedPlant);
      if (savedImage != null) {
        await photoNotifier.insertPhoto(plantId: id, photoPath: savedImage);
      }
    });
  }

  Future<void> insertWateringEvent({
    required int plantId,
    required DateTime date,
  }) async {
    final db = ref.read(databaseProvider);
    final id = await db.eventsDao.insertEvent(
      EventsCompanion(
        plantId: Value(plantId),
        eventType: Value('watering'),
        date: Value(dateTimeToDateString(date)),
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

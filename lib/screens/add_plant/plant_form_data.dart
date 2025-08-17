import 'package:drift/drift.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/utils/datetime_extensions.dart';

class PlantFormData {
  final int? id;
  final String name;
  final bool inSchedule;
  final double frequency;
  // final int windowSize;
  final String notes;
  final XFile? pickedImage;
  final DateTime? lastWatered;
  final bool isUpdate;

  PlantFormData({
    this.id,
    this.name = '',
    this.inSchedule = true,
    this.frequency = 7.0,
    this.notes = '',
    this.pickedImage,
    this.lastWatered,
    this.isUpdate = false,
  });

  static const _unset = Object();

  PlantFormData copyWith({
    String? name,
    bool? inSchedule,
    double? frequency,
    String? notes,
    Object? pickedImage = _unset,
    Object? lastWatered = _unset,
  }) {
    return PlantFormData(
      id: id,
      name: name ?? this.name,
      inSchedule: inSchedule ?? this.inSchedule,
      frequency: frequency ?? this.frequency,
      notes: notes ?? this.notes,
      pickedImage:
          pickedImage == _unset ? this.pickedImage : pickedImage as XFile?,
      lastWatered:
          lastWatered == _unset ? this.lastWatered : lastWatered as DateTime,
      isUpdate: isUpdate,
    );
  }

  PlantsCompanion toPlantCompanion() {
    final intFrequency = frequency.toInt();
    return PlantsCompanion(
      name: Value(name),
      // wateringFrequency: Value(intFrequency),
      inWateringSchedule: Value(inSchedule),
      notes: Value(notes),
      dateAdded: Value(DateTime.now().dateTimeToDateString()),
      minWateringDays: Value(intFrequency * 0.9), // 10% buffer below
      maxWateringDays: Value(intFrequency * 1.1), // 10% buffer above
      totalFeedback: Value(0),
      positiveFeedback: Value(0),
    );
  }

  PlantsCompanion toUpdateCompanion() {
    // final intFrequency = frequency.toInt();
    return PlantsCompanion(
      name: Value(name),
      // wateringFrequency: Value(intFrequency),
      inWateringSchedule: Value(inSchedule),
      notes: Value(notes),
      dateAdded: Value(DateTime.now().dateTimeToDateString()),
    );
  }
}

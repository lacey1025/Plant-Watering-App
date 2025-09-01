import 'package:drift/drift.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/utils/datetime_extensions.dart';

class PlantFormData {
  final int? id;
  final String name;
  final bool inSchedule;
  final double frequency;
  final String notes;
  final XFile? pickedImage;
  final DateTime? lastWatered;
  final bool isUpdate;
  final String? photoNotes;
  final DateTime photoDate;

  PlantFormData({
    this.id,
    this.name = '',
    this.inSchedule = true,
    this.frequency = 7.0,
    this.notes = '',
    this.pickedImage,
    this.lastWatered,
    this.isUpdate = false,
    this.photoNotes,
    DateTime? photoDate,
  }) : photoDate = photoDate ?? DateTime.now();

  static const _unset = Object();

  PlantFormData copyWith({
    String? name,
    bool? inSchedule,
    double? frequency,
    String? notes,
    Object? pickedImage = _unset,
    Object? lastWatered = _unset,
    String? photoNotes,
    DateTime? photoDate,
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
      photoNotes: photoNotes ?? this.photoNotes,
      photoDate: photoDate ?? this.photoDate,
    );
  }

  PlantsCompanion toPlantCompanion() {
    final intFrequency = frequency.toInt();
    return PlantsCompanion(
      name: Value(name),
      inWateringSchedule: Value(inSchedule),
      notes: Value(notes),
      dateAdded: Value(DateTime.now().dateTimeToDateString()),
      minWateringDays: Value(intFrequency * 0.9), // 10% buffer below
      maxWateringDays: Value(intFrequency * 1.1), // 10% buffer above
      totalFeedback: Value(0),
      positiveFeedback: Value(0),
    );
  }

  PhotosCompanion toPhotoCompanion(int plantId, String filepath) {
    return PhotosCompanion(
      plantId: Value(plantId),
      date: Value(photoDate.toString()),
      filePath: Value(filepath),
      notes: Value(photoNotes),
      isPrimary: Value(true),
    );
  }

  PlantsCompanion toUpdateCompanion() {
    return PlantsCompanion(
      name: Value(name),
      inWateringSchedule: Value(inSchedule),
      notes: notes.isNotEmpty ? Value(notes) : Value.absent(),
      dateAdded: Value(DateTime.now().dateTimeToDateString()),
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/notifier_providers/db_providers.dart';

class RepotData {
  final int id;
  final double potSize;
  final String soilType;
  final int plantId;
  final DateTime date;
  final String? notes;
  final int? daysSinceLast;

  RepotData({
    required this.id,
    required this.potSize,
    required this.soilType,
    required this.plantId,
    required this.date,
    this.notes,
    this.daysSinceLast,
  });

  RepotData copyWith({int? daysSinceLast}) => RepotData(
    id: id,
    potSize: potSize,
    soilType: soilType,
    plantId: plantId,
    date: date,
    notes: notes,
    daysSinceLast: daysSinceLast ?? this.daysSinceLast,
  );
}

final repotEventsForPlantProvider = StreamProvider.family
    .autoDispose<List<RepotData>, int>((ref, plantId) {
      final db = ref.read(databaseProvider);
      return db.eventsDao.watchRepotEventsForPlant(plantId);
    });

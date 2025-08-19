import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/database/plant_app_db.dart';

final databaseProvider = Provider<PlantAppDb>((ref) {
  return PlantAppDb();
});

final allPlantsProvider = StreamProvider<List<Plant>>((ref) {
  final db = ref.read(databaseProvider);
  return db.plantsDao.watchAllPlants();
});

final pesticideEventsForPlantProvider = StreamProvider.family
    .autoDispose<List<Event>, int>((ref, plantId) {
      final db = ref.read(databaseProvider);
      return db.eventsDao.watchPesticideEventsForPlant(plantId);
    });

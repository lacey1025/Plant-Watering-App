import 'package:drift/drift.dart';
import 'package:plant_application/database/plant_app_db.dart';

part 'plants_dao.g.dart';

@DriftAccessor(tables: [Plants, Events])
class PlantsDao extends DatabaseAccessor<PlantAppDb> with _$PlantsDaoMixin {
  PlantsDao(super.db);

  Stream<List<Plant>> watchAllPlants() {
    final query = select(plants);
    return query.watch();
  }

  Stream<Plant?> watchPlantById(int plantId) {
    final query = select(plants)..where((p) => p.id.equals(plantId));
    return query.watchSingleOrNull();
  }

  Future<Plant?> getPlantById(int plantId) {
    final query = select(plants)..where((p) => p.id.equals(plantId));
    return query.getSingleOrNull();
  }

  Future<int> insertPlant(PlantsCompanion plant) {
    return into(plants).insert(plant);
  }

  Future<bool> updatePlant(Plant plant) {
    return update(plants).replace(plant);
  }

  Future<void> updatePlantFromCompanion(
    int plantId,
    PlantsCompanion updates,
  ) async {
    await (update(plants)
      ..where((tbl) => tbl.id.equals(plantId))).write(updates);
  }

  Future<void> deletePlant(int plantId) async {
    await (delete(plants)..where((p) => p.id.equals(plantId))).go();
  }
}

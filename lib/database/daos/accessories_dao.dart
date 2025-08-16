import 'package:drift/drift.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/accessory_data.dart';

part 'accessories_dao.g.dart';

@DriftAccessor(tables: [EventAccessories, Accessories])
class AccessoriesDao extends DatabaseAccessor<PlantAppDb>
    with _$AccessoriesDaoMixin {
  AccessoriesDao(super.db);

  Stream<List<AccessoryData>> watchAccessoriesForEvent(int eventId) {
    final query = select(eventAccessories).join([
      innerJoin(
        accessories,
        accessories.id.equalsExp(eventAccessories.accessoryId),
      ),
    ])..where(eventAccessories.eventId.equals(eventId));

    return query.map((row) {
      return AccessoryData(
        id: row.readTable(accessories).id,
        type: row.readTable(accessories).type,
        name: row.readTable(accessories).name,
        strength: row.readTable(eventAccessories).strength,
      );
    }).watch(); // Changed from .get() to .watch()
  }

  Stream<List<Accessory>> watchAllActiveAccessories() {
    final query = select(accessories)..where((a) => a.isActive.equals(true));
    return query.watch();
  }

  Future<void> deactivateAccessory(int id) {
    return (update(accessories)..where(
      (a) => a.id.equals(id),
    )).write(AccessoriesCompanion(isActive: Value(false)));
  }

  Future<List<int>> getEventIdsByAccessory(int accessoryId) {
    return (select(eventAccessories)..where(
      (a) => a.accessoryId.equals(accessoryId),
    )).map((row) => row.eventId).get();
  }

  Future<void> deleteEventAccessoriesByEvents(List<int> eventIds) async {
    await (delete(eventAccessories)
      ..where((ea) => ea.eventId.isIn(eventIds))).go();
  }

  // Future<int> insertEventAccessory(
  //   EventAccessoriesCompanion eventAccessory,
  // ) async {
  //   return await into(eventAccessories).insert(eventAccessory);
  // }
  Future<int> insertAccessory(AccessoriesCompanion accessory) async {
    return await into(accessories).insert(accessory);
  }

  Future<int> updateAccessory(AccessoriesCompanion companion) {
    return (update(accessories)
      ..where((a) => a.id.equals(companion.id.value))).write(companion);
  }

  Future<void> deleteAccessory(int accessoryId) async {
    await (delete(accessories)..where((a) => a.id.equals(accessoryId))).go();
  }

  Future<void> insertEventAccessories(
    List<EventAccessoriesCompanion> accessories,
  ) async {
    await batch((batch) {
      batch.insertAll(eventAccessories, accessories);
    });
  }
}

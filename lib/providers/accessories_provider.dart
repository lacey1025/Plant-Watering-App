import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/event_types_enum.dart';
import 'package:plant_application/providers/db_provider.dart';

class AccessoriesNotifier extends StateNotifier<AsyncValue<List<Accessory>>> {
  AccessoriesNotifier(this.ref) : super(const AsyncValue.loading()) {
    _listenToDb();
  }

  final Ref ref;

  void _listenToDb() {
    final db = ref.read(databaseProvider);
    db.accessoriesDao.watchAllActiveAccessories().listen(
      (accessories) {
        state = AsyncValue.data(accessories);
      },
      onError: (err, st) {
        state = AsyncValue.error(err, st);
      },
    );
  }

  AccessoriesCompanion createAccessoryCompanion({
    EventType? type,
    String? name,
    String? notes,
  }) {
    return AccessoriesCompanion(
      type:
          (type != null)
              ? Value(type.toString().split('.').last)
              : Value.absent(),
      name: (name != null) ? Value(name) : Value.absent(),
      notes: (notes != null) ? Value(notes) : Value.absent(),
    );
  }

  Future<int> insertAccessory(AccessoriesCompanion accessory) async {
    final db = ref.read(databaseProvider);
    return await db.accessoriesDao.insertAccessory(accessory);
  }

  Future<void> deleteAccessory(int id) async {
    final db = ref.read(databaseProvider);
    final eventIds = await db.accessoriesDao.getEventIdsByAccessory(id);
    if (eventIds.isEmpty) {
      await db.accessoriesDao.deleteAccessory(id);
    } else {
      await db.accessoriesDao.deactivateAccessory(id);
    }
  }

  Future<void> updateAccessory(AccessoriesCompanion accessory) async {
    final db = ref.read(databaseProvider);
    await db.accessoriesDao.updateAccessory(accessory);
  }
}

final accessoriesNotifierProvider =
    StateNotifierProvider<AccessoriesNotifier, AsyncValue<List<Accessory>>>(
      (ref) => AccessoriesNotifier(ref),
    );

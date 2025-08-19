import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/providers/db_provider.dart';

// final primaryPhotoProvider = FutureProvider.family<Photo?, int>((
//   ref,
//   plantId,
// ) async {
//   final database = ref.read(databaseProvider);

//   return database.photosDao.getPrimaryPhoto(plantId);
// });

final primaryPhotoNotifierProvider =
    StateNotifierProvider.family<PrimaryPhotoNotifier, AsyncValue<Photo?>, int>(
      (ref, plantId) => PrimaryPhotoNotifier(ref, plantId),
    );

class PrimaryPhotoNotifier extends StateNotifier<AsyncValue<Photo?>> {
  final Ref ref;
  final int plantId;

  PrimaryPhotoNotifier(this.ref, this.plantId)
    : super(const AsyncValue.loading()) {
    loadPrimary();
  }

  Future<void> loadPrimary() async {
    state = const AsyncValue.loading();

    try {
      final database = ref.read(databaseProvider);
      final photo = await database.photosDao.getPrimaryPhoto(plantId);
      state = AsyncValue.data(photo);
    } catch (error, tr) {
      state = AsyncValue.error(error, tr);
    }
  }

  Future<void> setPrimary(int photoId) async {
    try {
      final db = ref.read(databaseProvider);
      await db.transaction(() async {
        await db.photosDao.makePrimary(photoId, plantId);
      });
      await loadPrimary();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void refresh() {
    loadPrimary();
  }
}

import 'package:drift/drift.dart';
import 'package:plant_application/database/plant_app_db.dart';

part 'photos_dao.g.dart';

@DriftAccessor(tables: [Photos])
class PhotosDao extends DatabaseAccessor<PlantAppDb> with _$PhotosDaoMixin {
  PhotosDao(super.db);

  Future<int> insertPhoto(PhotosCompanion photo) {
    return into(photos).insert(photo);
  }

  Stream<List<Photo>> watchAllPhotosForPlant(int plantId) {
    return (select(photos)
          ..where((tbl) => tbl.plantId.equals(plantId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
        .watch();
  }

  Future<void> updatePhoto(PhotosCompanion photo) {
    return (update(photos)
      ..where((tbl) => tbl.id.equals(photo.id.value))).write(photo);
  }

  Future<void> makePrimary(int photoId, int plantId) async {
    await (update(photos)..where(
      (p) => p.plantId.equals(plantId),
    )).write(PhotosCompanion(isPrimary: Value(false)));
    await (update(photos)..where(
      (p) => p.id.equals(photoId),
    )).write(PhotosCompanion(isPrimary: Value(true)));
  }

  Future<Photo?> getPrimaryPhoto(int plantId) {
    return (select(photos)..where(
      (p) => p.plantId.equals(plantId) & p.isPrimary.equals(true),
    )).getSingleOrNull();
  }

  Future<Photo?> getMostRecentPhoto(int plantId) {
    return (select(photos)
          ..where((p) => p.plantId.equals(plantId))
          ..orderBy([(p) => OrderingTerm.desc(p.date)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<void> deletePhotosByPlantId(int plantId) async {
    await (delete(photos)..where((p) => p.plantId.equals(plantId))).go();
  }

  Future<void> deletePhoto(int photoId) {
    return (delete(photos)..where((p) => p.id.equals(photoId))).go();
  }
}

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

  Future<void> deletePhotosByPlantId(int plantId) async {
    await (delete(photos)..where((p) => p.plantId.equals(plantId))).go();
  }
}

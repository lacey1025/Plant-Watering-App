import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/database/plant_app_db.dart';

final databaseProvider = Provider<PlantAppDb>((ref) {
  return PlantAppDb();
});

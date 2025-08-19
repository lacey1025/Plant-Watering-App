import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/notifier_providers/db_providers.dart';

class AccessoryData {
  final int id;
  final String type;
  final String name;
  final double? strength;

  AccessoryData({
    required this.id,
    required this.type,
    required this.name,
    this.strength,
  });
}

final accessoriesForEventProvider = StreamProvider.family
    .autoDispose<List<AccessoryData>, int>((ref, eventId) {
      final db = ref.read(databaseProvider);
      return db.accessoriesDao.watchAccessoriesForEvent(eventId);
    });

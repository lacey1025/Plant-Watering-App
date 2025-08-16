import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/accessory_data.dart';
import 'package:plant_application/models/plant_card_data.dart';
import 'package:plant_application/models/repot_data.dart';
import 'package:plant_application/models/water_event_data.dart';
import 'package:plant_application/providers/db_provider.dart';

final allPlantsProvider = StreamProvider<List<Plant>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.plantsDao.watchAllPlants();
});

final allWateringEventsProvider =
    StreamProvider<Map<int, List<WaterEventData>>>((ref) {
      final db = ref.watch(databaseProvider);
      return db.eventsDao.watchAllWateringEvents().map((events) {
        // Group events by plantId
        final Map<int, List<WaterEventData>> map = {};
        for (final event in events) {
          map.putIfAbsent(event.plantId, () => []).add(event);
        }
        for (final entry in map.entries) {
          final eventsForPlant = entry.value;
          for (int i = 1; i < eventsForPlant.length; i++) {
            final previous = eventsForPlant[i - 1];
            final current = eventsForPlant[i];
            final diff = current.date.difference(previous.date).inDays;
            eventsForPlant[i] = current.copyWith(daysSinceLast: diff);
          }
          map[entry.key] = eventsForPlant.reversed.toList();
        }
        return map;
      });
    });

// final allPesticideEventsProvider = StreamProvider<Map<int, List<Event>>>((ref) {
//   final db = ref.watch(databaseProvider);
//   return db.eventsDao.watchAllPesticideEvents().map((events) {
//     final Map<int, List<Event>> map = {};
//     for (final event in events) {
//       map.putIfAbsent(event.plantId, () => []).add(event);
//     }
//     return map;
//   });
// });

// final allRepotEventsProvider = StreamProvider<Map<int, List<RepotData>>>((ref) {
//   final db = ref.watch(databaseProvider);
//   return db.eventsDao.watchAllRepotEvents().map((events) {
//     final Map<int, List<RepotData>> map = {};
//     for (final event in events) {
//       map.putIfAbsent(event.plantId, () => []).add(event);
//     }
//     for (final entry in map.entries) {
//       final eventsForPlant = entry.value;
//       for (int i = 1; i < eventsForPlant.length; i++) {
//         final previous = eventsForPlant[i - 1];
//         final current = eventsForPlant[i];
//         final diff = current.date.difference(previous.date).inDays;
//         eventsForPlant[i] = current.copyWith(daysSinceLast: diff);
//       }
//       map[entry.key] = eventsForPlant.reversed.toList();
//     }
//     return map;
//   });
// });

// final allAccessoriesProvider = StreamProvider<List<Accessory>>((ref) {
//   final db = ref.watch(databaseProvider);
//   return db.accessoriesDao.watchAllAccessories();
// });

// final plantCardsProvider = FutureProvider<List<PlantCardData>>((ref) async {
//   final db = ref.watch(databaseProvider);
//   final plants = await db.plantsDao.getPlantCardRows();

//   return plants.map((plant) {
//     final earliestNextWatering =
//         (plant.wateringFrequency != null)
//             ? plant.lastWatered?.add(
//               Duration(days: plant.wateringFrequency! - 1),
//             )
//             : null;
//     final latestNextWatering =
//         (plant.wateringFrequency != null)
//             ? plant.lastWatered?.add(
//               Duration(days: plant.wateringFrequency! + 1),
//             )
//             : null;
//     return plant.copyWith(
//       latestNextWater: latestNextWatering,
//       earliersNextWater: earliestNextWatering,
//     );
//   }).toList();
// });

final plantCardsProvider = FutureProvider<List<PlantCardData>>((ref) async {
  final plants = await ref.watch(allPlantsProvider.future);
  final wateringEvents = await ref.watch(allWateringEventsProvider.future);

  return plants.map((plant) {
    final events = wateringEvents[plant.id] ?? [];
    return PlantCardData.buildPlantCardData(plant, events);
  }).toList();
});

// Used in view plant screen
// final plantProvider = StreamProvider.family.autoDispose<Plant?, int>((
//   ref,
//   plantId,
// ) {
//   final db = ref.watch(databaseProvider);
//   return db.plantsDao.watchPlantById(plantId);
// });

// Used in view plant screen
final wateringEventsForPlantProvider = StreamProvider.family
    .autoDispose<List<WaterEventData>, int>((ref, plantId) {
      final db = ref.watch(databaseProvider);
      return db.eventsDao.watchWateringEventsForPlant(plantId);
    });

// Used in view plant screen
final repotEventsForPlantProvider = StreamProvider.family
    .autoDispose<List<RepotData>, int>((ref, plantId) {
      final db = ref.watch(databaseProvider);
      return db.eventsDao.watchRepotEventsForPlant(plantId);
    });

// Used in view plant screen
final pesticideEventsForPlantProvider = StreamProvider.family
    .autoDispose<List<Event>, int>((ref, plantId) {
      final db = ref.watch(databaseProvider);
      return db.eventsDao.watchPesticideEventsForPlant(plantId);
    });

final accessoriesForEventProvider = StreamProvider.family
    .autoDispose<List<AccessoryData>, int>((ref, eventId) {
      final db = ref.watch(databaseProvider);
      return db.accessoriesDao.watchAccessoriesForEvent(eventId);
    });

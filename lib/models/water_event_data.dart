import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_application/models/enums/timing_enum.dart';
import 'package:plant_application/notifier_providers/db_providers.dart';

class WaterEventData {
  final int id;
  final int plantId;
  final DateTime date;
  final String? notes;
  final int? daysSinceLast;
  final Timing? timingFeedback;
  final int? offsetDays;

  WaterEventData({
    required this.id,
    required this.plantId,
    required this.date,
    this.notes,
    this.daysSinceLast,
    this.timingFeedback,
    this.offsetDays,
  });

  WaterEventData copyWith({int? daysSinceLast}) => WaterEventData(
    id: id,
    plantId: plantId,
    date: date,
    notes: notes,
    timingFeedback: timingFeedback,
    offsetDays: offsetDays,
    daysSinceLast: daysSinceLast ?? this.daysSinceLast,
  );
}

final wateringEventsForPlantProvider = StreamProvider.family
    .autoDispose<List<WaterEventData>, int>((ref, plantId) {
      final db = ref.read(databaseProvider);
      return db.eventsDao.watchWateringEventsForPlant(plantId);
    });

final allWateringEventsProvider =
    StreamProvider<Map<int, List<WaterEventData>>>((ref) {
      final db = ref.read(databaseProvider);
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

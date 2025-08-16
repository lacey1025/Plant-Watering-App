import 'package:drift/drift.dart';
import 'package:plant_application/database/converters.dart';
import 'package:plant_application/database/plant_app_db.dart';
import 'package:plant_application/models/repot_data.dart';
import 'package:plant_application/models/water_event_data.dart';

part 'events_dao.g.dart';

@DriftAccessor(tables: [Events, RepotEvents, WaterEvents])
class EventsDao extends DatabaseAccessor<PlantAppDb> with _$EventsDaoMixin {
  EventsDao(super.db);

  Stream<List<WaterEventData>> watchAllWateringEvents() {
    final query = customSelect(
      '''
      SELECT
        events.id AS id,
        events.plant_id AS plantId,
        events.date AS date,
        events.notes AS notes,
        water_events.timing_feedback AS timingFeedback,
        water_events.offset_days AS offsetDays
      FROM events
      JOIN water_events ON water_events.event_id = events.id
      WHERE events.event_type = 'watering'
      ORDER BY events.date ASC
      ''',
      readsFrom: {events, waterEvents},
    );

    return query.watch().map((rows) {
      return rows.map((row) {
        final data = row.data;
        return WaterEventData(
          id: data['id'] as int,
          plantId: data['plantId'] as int,
          date: DateTime.parse(data['date']),
          notes: data['notes'] as String?,
          offsetDays: data['offsetDays'] as int?,
          timingFeedback: stringToTiming(data['timingFeedback'] as String?),
        );
      }).toList();
    });
  }

  Stream<List<Event>> watchAllPesticideEvents() {
    final query = customSelect(
      '''
      SELECT *
      FROM events
      WHERE event_type = 'pesticide'
      ORDER BY events.date DESC
      ''',
      readsFrom: {events},
    );

    return query.watch().map((rows) {
      return rows.map((row) {
        return Event.fromJson(row.data);
      }).toList();
    });
  }

  Stream<List<RepotData>> watchAllRepotEvents() {
    final query = customSelect(
      '''
    SELECT 
      events.id AS id,
      repot_events.pot_size AS potSize,
      repot_events.soil_type AS soilType,
      events.plant_id AS plantId,
      events.date AS date,
      events.notes AS notes
    FROM events
    JOIN repot_events ON repot_events.event_id = events.id
    WHERE events.event_type = 'repot'
    ORDER BY events.date ASC
    ''',
      readsFrom: {events, repotEvents},
    );

    return query.watch().map((rows) {
      return rows.map((row) {
        final data = row.data;
        return RepotData(
          id: data['id'] as int,
          potSize: data['potSize'] as int,
          soilType: data['soilType'] as String,
          plantId: data['plantId'] as int,
          date: DateTime.parse(data['date']),
          notes: data['notes'] as String?,
        );
      }).toList();
    });
  }

  Future<List<int>> getEventIdsByPlantId(int plantId) async {
    final eventIds =
        await (select(events)
          ..where((e) => e.plantId.equals(plantId))).map((e) => e.id).get();
    return eventIds;
  }

  Future<void> deleteEventsByPlantId(int plantId) async {
    await (delete(events)..where((e) => e.plantId.equals(plantId))).go();
  }

  Future<void> deleteEvent(int eventId) async {
    await (delete(events)..where((e) => e.id.equals(eventId))).go();
  }

  Future<void> updateEventFromCompanion(
    int eventId,
    EventsCompanion updates,
  ) async {
    await (update(events)
      ..where((tbl) => tbl.id.equals(eventId))).write(updates);
  }

  Future<void> updateWaterEventFromCompanion(
    int eventId,
    WaterEventsCompanion updates,
  ) async {
    await (update(waterEvents)
      ..where((tbl) => tbl.eventId.equals(eventId))).write(updates);
  }

  Future<void> deleteRepotEvents(List<int> eventIds) async {
    await (delete(repotEvents)..where((r) => r.eventId.isIn(eventIds))).go();
  }

  Future<void> deleteWaterEvents(List<int> eventIds) async {
    await (delete(waterEvents)..where((w) => w.eventId.isIn(eventIds))).go();
  }

  Future<int> insertEvent(EventsCompanion event) async {
    return await into(events).insert(event);
  }

  Future<int> insertWaterEvent(WaterEventsCompanion waterEvent) async {
    return await into(waterEvents).insert(waterEvent);
  }

  Future<int> insertRepotEvent(RepotEventsCompanion repotEvent) async {
    return await into(repotEvents).insert(repotEvent);
  }

  Stream<List<WaterEventData>> watchWateringEventsForPlant(int plantId) {
    final query = customSelect(
      '''
      SELECT 
        events.id AS id,
        events.plant_id AS plantId,
        events.date AS date,
        events.notes AS notes,
        water_events.timing_feedback AS timingFeedback,
        water_events.offset_days AS offsetDays
      FROM events
      JOIN water_events ON water_events.event_id = events.id
      WHERE events.event_type = 'watering' AND events.plant_id = ?
      ORDER BY events.date ASC
      ''',
      variables: [Variable<int>(plantId)],
      readsFrom: {events, waterEvents},
    );

    return query.watch().map((rows) {
      final list =
          rows.map((row) {
            final data = row.data;
            return WaterEventData(
              id: data['id'] as int,
              plantId: data['plantId'] as int,
              date: DateTime.parse(data['date']),
              notes: data['notes'] as String?,
              offsetDays: data['offsetDays'] as int?,
              timingFeedback: stringToTiming(data['timingFeedback'] as String?),
            );
          }).toList();

      for (int i = 1; i < list.length; i++) {
        final prev = list[i - 1];
        final curr = list[i];
        final diff = curr.date.difference(prev.date).inDays;
        list[i] = curr.copyWith(daysSinceLast: diff);
      }
      return list.reversed.toList();
    });
  }

  Stream<List<RepotData>> watchRepotEventsForPlant(int plantId) {
    final query =
        select(events).join([
            innerJoin(repotEvents, repotEvents.eventId.equalsExp(events.id)),
          ])
          ..where(events.plantId.equals(plantId))
          ..orderBy([OrderingTerm.asc(events.date)]);

    return query.watch().map((rows) {
      final list =
          rows.map((row) {
            final event = row.readTable(events);
            final repot = row.readTable(repotEvents);

            return RepotData(
              id: event.id,
              potSize: repot.potSize,
              soilType: repot.soilType,
              plantId: event.plantId,
              date: DateTime.parse(event.date),
              notes: event.notes,
              daysSinceLast: null,
            );
          }).toList();
      for (int i = 1; i < list.length; i++) {
        final prev = list[i - 1];
        final curr = list[i];
        final diff = curr.date.difference(prev.date).inDays;
        list[i] = curr.copyWith(daysSinceLast: diff);
      }
      return list.reversed.toList();
    });
  }

  Stream<List<Event>> watchPesticideEventsForPlant(int plantId) {
    final q = customSelect(
      '''
      SELECT *
      FROM events e
      WHERE e.event_type = 'pesticide' AND e.plant_id = ?
      ORDER BY e.date DESC
      ''',
      variables: [Variable<int>(plantId)],
      readsFrom: {events},
    );

    return q.watch().map((rows) {
      return rows.map((row) => events.map(row.data)).toList();
    });
  }
}

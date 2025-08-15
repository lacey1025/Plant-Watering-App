import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plant_application/database/daos/accessories_dao.dart';
import 'package:plant_application/database/daos/events_dao.dart';
import 'package:plant_application/database/daos/photos_dao.dart';
import 'package:plant_application/database/daos/plants_dao.dart';

part 'plant_app_db.g.dart';

@DriftDatabase(
  tables: [
    Plants,
    Accessories,
    Events,
    EventAccessories,
    RepotEvents,
    WaterEvents,
    Photos,
  ],
  daos: [PlantsDao, EventsDao, PhotosDao, AccessoriesDao],
)
class PlantAppDb extends _$PlantAppDb {
  PlantAppDb([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationSupportDirectory();
      final file = File('${dbFolder.path}/plant_app_database.sqlite');
      return NativeDatabase(file);
    });
  }
}

@DataClassName('Plant')
class Plants extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  // IntColumn get wateringFrequency => integer().nullable()();
  BoolColumn get inWateringSchedule => boolean()();
  TextColumn get notes => text().nullable()();
  TextColumn get dateAdded => text()();
  RealColumn get minWateringDays => real().nullable()();
  RealColumn get maxWateringDays => real().nullable()();
  IntColumn get totalFeedback => integer().withDefault(const Constant(0))();
  IntColumn get positiveFeedback => integer().withDefault(const Constant(0))();
}

@DataClassName('Accessory')
class Accessories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text().withLength(max: 20)();
  TextColumn get name => text()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

@DataClassName('Event')
class Events extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get plantId => integer().references(Plants, #id)();
  TextColumn get eventType => text().withLength(max: 20)();
  TextColumn get date => text()();
  TextColumn get notes => text().nullable()();
}

@DataClassName('EventAccessory')
class EventAccessories extends Table {
  IntColumn get eventId => integer().references(Events, #id)();
  IntColumn get accessoryId => integer().references(Accessories, #id)();
  RealColumn get strength => real().nullable()();

  @override
  Set<Column> get primaryKey => {eventId, accessoryId};
}

@DataClassName('WaterEvent')
class WaterEvents extends Table {
  IntColumn get eventId => integer().references(Events, #id)();
  TextColumn get timingFeedback => text().nullable()();
  IntColumn get offsetDays => integer().nullable()();
}

@DataClassName('RepotEvent')
class RepotEvents extends Table {
  IntColumn get eventId => integer().references(Events, #id)();
  IntColumn get potSize => integer()();
  TextColumn get soilType => text()();
}

@DataClassName('Photo')
class Photos extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get plantId => integer().references(Plants, #id)();
  TextColumn get date => text()();
  TextColumn get filePath => text()();
}

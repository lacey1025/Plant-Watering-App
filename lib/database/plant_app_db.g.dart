// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_app_db.dart';

// ignore_for_file: type=lint
class $PlantsTable extends Plants with TableInfo<$PlantsTable, Plant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inWateringScheduleMeta =
      const VerificationMeta('inWateringSchedule');
  @override
  late final GeneratedColumn<bool> inWateringSchedule = GeneratedColumn<bool>(
    'in_watering_schedule',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("in_watering_schedule" IN (0, 1))',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateAddedMeta = const VerificationMeta(
    'dateAdded',
  );
  @override
  late final GeneratedColumn<String> dateAdded = GeneratedColumn<String>(
    'date_added',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minWateringDaysMeta = const VerificationMeta(
    'minWateringDays',
  );
  @override
  late final GeneratedColumn<double> minWateringDays = GeneratedColumn<double>(
    'min_watering_days',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxWateringDaysMeta = const VerificationMeta(
    'maxWateringDays',
  );
  @override
  late final GeneratedColumn<double> maxWateringDays = GeneratedColumn<double>(
    'max_watering_days',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalFeedbackMeta = const VerificationMeta(
    'totalFeedback',
  );
  @override
  late final GeneratedColumn<int> totalFeedback = GeneratedColumn<int>(
    'total_feedback',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _positiveFeedbackMeta = const VerificationMeta(
    'positiveFeedback',
  );
  @override
  late final GeneratedColumn<int> positiveFeedback = GeneratedColumn<int>(
    'positive_feedback',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    inWateringSchedule,
    notes,
    dateAdded,
    minWateringDays,
    maxWateringDays,
    totalFeedback,
    positiveFeedback,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plants';
  @override
  VerificationContext validateIntegrity(
    Insertable<Plant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('in_watering_schedule')) {
      context.handle(
        _inWateringScheduleMeta,
        inWateringSchedule.isAcceptableOrUnknown(
          data['in_watering_schedule']!,
          _inWateringScheduleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_inWateringScheduleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('date_added')) {
      context.handle(
        _dateAddedMeta,
        dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta),
      );
    } else if (isInserting) {
      context.missing(_dateAddedMeta);
    }
    if (data.containsKey('min_watering_days')) {
      context.handle(
        _minWateringDaysMeta,
        minWateringDays.isAcceptableOrUnknown(
          data['min_watering_days']!,
          _minWateringDaysMeta,
        ),
      );
    }
    if (data.containsKey('max_watering_days')) {
      context.handle(
        _maxWateringDaysMeta,
        maxWateringDays.isAcceptableOrUnknown(
          data['max_watering_days']!,
          _maxWateringDaysMeta,
        ),
      );
    }
    if (data.containsKey('total_feedback')) {
      context.handle(
        _totalFeedbackMeta,
        totalFeedback.isAcceptableOrUnknown(
          data['total_feedback']!,
          _totalFeedbackMeta,
        ),
      );
    }
    if (data.containsKey('positive_feedback')) {
      context.handle(
        _positiveFeedbackMeta,
        positiveFeedback.isAcceptableOrUnknown(
          data['positive_feedback']!,
          _positiveFeedbackMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Plant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Plant(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      inWateringSchedule:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}in_watering_schedule'],
          )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      dateAdded:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}date_added'],
          )!,
      minWateringDays: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_watering_days'],
      ),
      maxWateringDays: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}max_watering_days'],
      ),
      totalFeedback:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}total_feedback'],
          )!,
      positiveFeedback:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}positive_feedback'],
          )!,
    );
  }

  @override
  $PlantsTable createAlias(String alias) {
    return $PlantsTable(attachedDatabase, alias);
  }
}

class Plant extends DataClass implements Insertable<Plant> {
  final int id;
  final String name;
  final bool inWateringSchedule;
  final String? notes;
  final String dateAdded;
  final double? minWateringDays;
  final double? maxWateringDays;
  final int totalFeedback;
  final int positiveFeedback;
  const Plant({
    required this.id,
    required this.name,
    required this.inWateringSchedule,
    this.notes,
    required this.dateAdded,
    this.minWateringDays,
    this.maxWateringDays,
    required this.totalFeedback,
    required this.positiveFeedback,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['in_watering_schedule'] = Variable<bool>(inWateringSchedule);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['date_added'] = Variable<String>(dateAdded);
    if (!nullToAbsent || minWateringDays != null) {
      map['min_watering_days'] = Variable<double>(minWateringDays);
    }
    if (!nullToAbsent || maxWateringDays != null) {
      map['max_watering_days'] = Variable<double>(maxWateringDays);
    }
    map['total_feedback'] = Variable<int>(totalFeedback);
    map['positive_feedback'] = Variable<int>(positiveFeedback);
    return map;
  }

  PlantsCompanion toCompanion(bool nullToAbsent) {
    return PlantsCompanion(
      id: Value(id),
      name: Value(name),
      inWateringSchedule: Value(inWateringSchedule),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      dateAdded: Value(dateAdded),
      minWateringDays:
          minWateringDays == null && nullToAbsent
              ? const Value.absent()
              : Value(minWateringDays),
      maxWateringDays:
          maxWateringDays == null && nullToAbsent
              ? const Value.absent()
              : Value(maxWateringDays),
      totalFeedback: Value(totalFeedback),
      positiveFeedback: Value(positiveFeedback),
    );
  }

  factory Plant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Plant(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      inWateringSchedule: serializer.fromJson<bool>(json['inWateringSchedule']),
      notes: serializer.fromJson<String?>(json['notes']),
      dateAdded: serializer.fromJson<String>(json['dateAdded']),
      minWateringDays: serializer.fromJson<double?>(json['minWateringDays']),
      maxWateringDays: serializer.fromJson<double?>(json['maxWateringDays']),
      totalFeedback: serializer.fromJson<int>(json['totalFeedback']),
      positiveFeedback: serializer.fromJson<int>(json['positiveFeedback']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'inWateringSchedule': serializer.toJson<bool>(inWateringSchedule),
      'notes': serializer.toJson<String?>(notes),
      'dateAdded': serializer.toJson<String>(dateAdded),
      'minWateringDays': serializer.toJson<double?>(minWateringDays),
      'maxWateringDays': serializer.toJson<double?>(maxWateringDays),
      'totalFeedback': serializer.toJson<int>(totalFeedback),
      'positiveFeedback': serializer.toJson<int>(positiveFeedback),
    };
  }

  Plant copyWith({
    int? id,
    String? name,
    bool? inWateringSchedule,
    Value<String?> notes = const Value.absent(),
    String? dateAdded,
    Value<double?> minWateringDays = const Value.absent(),
    Value<double?> maxWateringDays = const Value.absent(),
    int? totalFeedback,
    int? positiveFeedback,
  }) => Plant(
    id: id ?? this.id,
    name: name ?? this.name,
    inWateringSchedule: inWateringSchedule ?? this.inWateringSchedule,
    notes: notes.present ? notes.value : this.notes,
    dateAdded: dateAdded ?? this.dateAdded,
    minWateringDays:
        minWateringDays.present ? minWateringDays.value : this.minWateringDays,
    maxWateringDays:
        maxWateringDays.present ? maxWateringDays.value : this.maxWateringDays,
    totalFeedback: totalFeedback ?? this.totalFeedback,
    positiveFeedback: positiveFeedback ?? this.positiveFeedback,
  );
  Plant copyWithCompanion(PlantsCompanion data) {
    return Plant(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      inWateringSchedule:
          data.inWateringSchedule.present
              ? data.inWateringSchedule.value
              : this.inWateringSchedule,
      notes: data.notes.present ? data.notes.value : this.notes,
      dateAdded: data.dateAdded.present ? data.dateAdded.value : this.dateAdded,
      minWateringDays:
          data.minWateringDays.present
              ? data.minWateringDays.value
              : this.minWateringDays,
      maxWateringDays:
          data.maxWateringDays.present
              ? data.maxWateringDays.value
              : this.maxWateringDays,
      totalFeedback:
          data.totalFeedback.present
              ? data.totalFeedback.value
              : this.totalFeedback,
      positiveFeedback:
          data.positiveFeedback.present
              ? data.positiveFeedback.value
              : this.positiveFeedback,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Plant(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('inWateringSchedule: $inWateringSchedule, ')
          ..write('notes: $notes, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('minWateringDays: $minWateringDays, ')
          ..write('maxWateringDays: $maxWateringDays, ')
          ..write('totalFeedback: $totalFeedback, ')
          ..write('positiveFeedback: $positiveFeedback')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    inWateringSchedule,
    notes,
    dateAdded,
    minWateringDays,
    maxWateringDays,
    totalFeedback,
    positiveFeedback,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Plant &&
          other.id == this.id &&
          other.name == this.name &&
          other.inWateringSchedule == this.inWateringSchedule &&
          other.notes == this.notes &&
          other.dateAdded == this.dateAdded &&
          other.minWateringDays == this.minWateringDays &&
          other.maxWateringDays == this.maxWateringDays &&
          other.totalFeedback == this.totalFeedback &&
          other.positiveFeedback == this.positiveFeedback);
}

class PlantsCompanion extends UpdateCompanion<Plant> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> inWateringSchedule;
  final Value<String?> notes;
  final Value<String> dateAdded;
  final Value<double?> minWateringDays;
  final Value<double?> maxWateringDays;
  final Value<int> totalFeedback;
  final Value<int> positiveFeedback;
  const PlantsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.inWateringSchedule = const Value.absent(),
    this.notes = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.minWateringDays = const Value.absent(),
    this.maxWateringDays = const Value.absent(),
    this.totalFeedback = const Value.absent(),
    this.positiveFeedback = const Value.absent(),
  });
  PlantsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required bool inWateringSchedule,
    this.notes = const Value.absent(),
    required String dateAdded,
    this.minWateringDays = const Value.absent(),
    this.maxWateringDays = const Value.absent(),
    this.totalFeedback = const Value.absent(),
    this.positiveFeedback = const Value.absent(),
  }) : name = Value(name),
       inWateringSchedule = Value(inWateringSchedule),
       dateAdded = Value(dateAdded);
  static Insertable<Plant> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? inWateringSchedule,
    Expression<String>? notes,
    Expression<String>? dateAdded,
    Expression<double>? minWateringDays,
    Expression<double>? maxWateringDays,
    Expression<int>? totalFeedback,
    Expression<int>? positiveFeedback,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (inWateringSchedule != null)
        'in_watering_schedule': inWateringSchedule,
      if (notes != null) 'notes': notes,
      if (dateAdded != null) 'date_added': dateAdded,
      if (minWateringDays != null) 'min_watering_days': minWateringDays,
      if (maxWateringDays != null) 'max_watering_days': maxWateringDays,
      if (totalFeedback != null) 'total_feedback': totalFeedback,
      if (positiveFeedback != null) 'positive_feedback': positiveFeedback,
    });
  }

  PlantsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? inWateringSchedule,
    Value<String?>? notes,
    Value<String>? dateAdded,
    Value<double?>? minWateringDays,
    Value<double?>? maxWateringDays,
    Value<int>? totalFeedback,
    Value<int>? positiveFeedback,
  }) {
    return PlantsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      inWateringSchedule: inWateringSchedule ?? this.inWateringSchedule,
      notes: notes ?? this.notes,
      dateAdded: dateAdded ?? this.dateAdded,
      minWateringDays: minWateringDays ?? this.minWateringDays,
      maxWateringDays: maxWateringDays ?? this.maxWateringDays,
      totalFeedback: totalFeedback ?? this.totalFeedback,
      positiveFeedback: positiveFeedback ?? this.positiveFeedback,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (inWateringSchedule.present) {
      map['in_watering_schedule'] = Variable<bool>(inWateringSchedule.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (dateAdded.present) {
      map['date_added'] = Variable<String>(dateAdded.value);
    }
    if (minWateringDays.present) {
      map['min_watering_days'] = Variable<double>(minWateringDays.value);
    }
    if (maxWateringDays.present) {
      map['max_watering_days'] = Variable<double>(maxWateringDays.value);
    }
    if (totalFeedback.present) {
      map['total_feedback'] = Variable<int>(totalFeedback.value);
    }
    if (positiveFeedback.present) {
      map['positive_feedback'] = Variable<int>(positiveFeedback.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlantsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('inWateringSchedule: $inWateringSchedule, ')
          ..write('notes: $notes, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('minWateringDays: $minWateringDays, ')
          ..write('maxWateringDays: $maxWateringDays, ')
          ..write('totalFeedback: $totalFeedback, ')
          ..write('positiveFeedback: $positiveFeedback')
          ..write(')'))
        .toString();
  }
}

class $AccessoriesTable extends Accessories
    with TableInfo<$AccessoriesTable, Accessory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccessoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, type, name, notes, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accessories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Accessory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Accessory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Accessory(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
    );
  }

  @override
  $AccessoriesTable createAlias(String alias) {
    return $AccessoriesTable(attachedDatabase, alias);
  }
}

class Accessory extends DataClass implements Insertable<Accessory> {
  final int id;
  final String type;
  final String name;
  final String? notes;
  final bool isActive;
  const Accessory({
    required this.id,
    required this.type,
    required this.name,
    this.notes,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  AccessoriesCompanion toCompanion(bool nullToAbsent) {
    return AccessoriesCompanion(
      id: Value(id),
      type: Value(type),
      name: Value(name),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      isActive: Value(isActive),
    );
  }

  factory Accessory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Accessory(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      notes: serializer.fromJson<String?>(json['notes']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'notes': serializer.toJson<String?>(notes),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  Accessory copyWith({
    int? id,
    String? type,
    String? name,
    Value<String?> notes = const Value.absent(),
    bool? isActive,
  }) => Accessory(
    id: id ?? this.id,
    type: type ?? this.type,
    name: name ?? this.name,
    notes: notes.present ? notes.value : this.notes,
    isActive: isActive ?? this.isActive,
  );
  Accessory copyWithCompanion(AccessoriesCompanion data) {
    return Accessory(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      notes: data.notes.present ? data.notes.value : this.notes,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Accessory(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, name, notes, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Accessory &&
          other.id == this.id &&
          other.type == this.type &&
          other.name == this.name &&
          other.notes == this.notes &&
          other.isActive == this.isActive);
}

class AccessoriesCompanion extends UpdateCompanion<Accessory> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> name;
  final Value<String?> notes;
  final Value<bool> isActive;
  const AccessoriesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  AccessoriesCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String name,
    this.notes = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : type = Value(type),
       name = Value(name);
  static Insertable<Accessory> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? name,
    Expression<String>? notes,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (notes != null) 'notes': notes,
      if (isActive != null) 'is_active': isActive,
    });
  }

  AccessoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<String>? name,
    Value<String?>? notes,
    Value<bool>? isActive,
  }) {
    return AccessoriesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccessoriesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $EventsTable extends Events with TableInfo<$EventsTable, Event> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _plantIdMeta = const VerificationMeta(
    'plantId',
  );
  @override
  late final GeneratedColumn<int> plantId = GeneratedColumn<int>(
    'plant_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plants (id)',
    ),
  );
  static const VerificationMeta _eventTypeMeta = const VerificationMeta(
    'eventType',
  );
  @override
  late final GeneratedColumn<String> eventType = GeneratedColumn<String>(
    'event_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 20),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, plantId, eventType, date, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'events';
  @override
  VerificationContext validateIntegrity(
    Insertable<Event> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plant_id')) {
      context.handle(
        _plantIdMeta,
        plantId.isAcceptableOrUnknown(data['plant_id']!, _plantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_plantIdMeta);
    }
    if (data.containsKey('event_type')) {
      context.handle(
        _eventTypeMeta,
        eventType.isAcceptableOrUnknown(data['event_type']!, _eventTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_eventTypeMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Event map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Event(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      plantId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}plant_id'],
          )!,
      eventType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}event_type'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}date'],
          )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $EventsTable createAlias(String alias) {
    return $EventsTable(attachedDatabase, alias);
  }
}

class Event extends DataClass implements Insertable<Event> {
  final int id;
  final int plantId;
  final String eventType;
  final String date;
  final String? notes;
  const Event({
    required this.id,
    required this.plantId,
    required this.eventType,
    required this.date,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plant_id'] = Variable<int>(plantId);
    map['event_type'] = Variable<String>(eventType);
    map['date'] = Variable<String>(date);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  EventsCompanion toCompanion(bool nullToAbsent) {
    return EventsCompanion(
      id: Value(id),
      plantId: Value(plantId),
      eventType: Value(eventType),
      date: Value(date),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory Event.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Event(
      id: serializer.fromJson<int>(json['id']),
      plantId: serializer.fromJson<int>(json['plantId']),
      eventType: serializer.fromJson<String>(json['eventType']),
      date: serializer.fromJson<String>(json['date']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plantId': serializer.toJson<int>(plantId),
      'eventType': serializer.toJson<String>(eventType),
      'date': serializer.toJson<String>(date),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Event copyWith({
    int? id,
    int? plantId,
    String? eventType,
    String? date,
    Value<String?> notes = const Value.absent(),
  }) => Event(
    id: id ?? this.id,
    plantId: plantId ?? this.plantId,
    eventType: eventType ?? this.eventType,
    date: date ?? this.date,
    notes: notes.present ? notes.value : this.notes,
  );
  Event copyWithCompanion(EventsCompanion data) {
    return Event(
      id: data.id.present ? data.id.value : this.id,
      plantId: data.plantId.present ? data.plantId.value : this.plantId,
      eventType: data.eventType.present ? data.eventType.value : this.eventType,
      date: data.date.present ? data.date.value : this.date,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Event(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('eventType: $eventType, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, plantId, eventType, date, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Event &&
          other.id == this.id &&
          other.plantId == this.plantId &&
          other.eventType == this.eventType &&
          other.date == this.date &&
          other.notes == this.notes);
}

class EventsCompanion extends UpdateCompanion<Event> {
  final Value<int> id;
  final Value<int> plantId;
  final Value<String> eventType;
  final Value<String> date;
  final Value<String?> notes;
  const EventsCompanion({
    this.id = const Value.absent(),
    this.plantId = const Value.absent(),
    this.eventType = const Value.absent(),
    this.date = const Value.absent(),
    this.notes = const Value.absent(),
  });
  EventsCompanion.insert({
    this.id = const Value.absent(),
    required int plantId,
    required String eventType,
    required String date,
    this.notes = const Value.absent(),
  }) : plantId = Value(plantId),
       eventType = Value(eventType),
       date = Value(date);
  static Insertable<Event> custom({
    Expression<int>? id,
    Expression<int>? plantId,
    Expression<String>? eventType,
    Expression<String>? date,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plantId != null) 'plant_id': plantId,
      if (eventType != null) 'event_type': eventType,
      if (date != null) 'date': date,
      if (notes != null) 'notes': notes,
    });
  }

  EventsCompanion copyWith({
    Value<int>? id,
    Value<int>? plantId,
    Value<String>? eventType,
    Value<String>? date,
    Value<String?>? notes,
  }) {
    return EventsCompanion(
      id: id ?? this.id,
      plantId: plantId ?? this.plantId,
      eventType: eventType ?? this.eventType,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (plantId.present) {
      map['plant_id'] = Variable<int>(plantId.value);
    }
    if (eventType.present) {
      map['event_type'] = Variable<String>(eventType.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsCompanion(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('eventType: $eventType, ')
          ..write('date: $date, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $EventAccessoriesTable extends EventAccessories
    with TableInfo<$EventAccessoriesTable, EventAccessory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventAccessoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<int> eventId = GeneratedColumn<int>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id)',
    ),
  );
  static const VerificationMeta _accessoryIdMeta = const VerificationMeta(
    'accessoryId',
  );
  @override
  late final GeneratedColumn<int> accessoryId = GeneratedColumn<int>(
    'accessory_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accessories (id)',
    ),
  );
  static const VerificationMeta _strengthMeta = const VerificationMeta(
    'strength',
  );
  @override
  late final GeneratedColumn<double> strength = GeneratedColumn<double>(
    'strength',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [eventId, accessoryId, strength];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_accessories';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventAccessory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('accessory_id')) {
      context.handle(
        _accessoryIdMeta,
        accessoryId.isAcceptableOrUnknown(
          data['accessory_id']!,
          _accessoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accessoryIdMeta);
    }
    if (data.containsKey('strength')) {
      context.handle(
        _strengthMeta,
        strength.isAcceptableOrUnknown(data['strength']!, _strengthMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {eventId, accessoryId};
  @override
  EventAccessory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventAccessory(
      eventId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}event_id'],
          )!,
      accessoryId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}accessory_id'],
          )!,
      strength: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}strength'],
      ),
    );
  }

  @override
  $EventAccessoriesTable createAlias(String alias) {
    return $EventAccessoriesTable(attachedDatabase, alias);
  }
}

class EventAccessory extends DataClass implements Insertable<EventAccessory> {
  final int eventId;
  final int accessoryId;
  final double? strength;
  const EventAccessory({
    required this.eventId,
    required this.accessoryId,
    this.strength,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<int>(eventId);
    map['accessory_id'] = Variable<int>(accessoryId);
    if (!nullToAbsent || strength != null) {
      map['strength'] = Variable<double>(strength);
    }
    return map;
  }

  EventAccessoriesCompanion toCompanion(bool nullToAbsent) {
    return EventAccessoriesCompanion(
      eventId: Value(eventId),
      accessoryId: Value(accessoryId),
      strength:
          strength == null && nullToAbsent
              ? const Value.absent()
              : Value(strength),
    );
  }

  factory EventAccessory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventAccessory(
      eventId: serializer.fromJson<int>(json['eventId']),
      accessoryId: serializer.fromJson<int>(json['accessoryId']),
      strength: serializer.fromJson<double?>(json['strength']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<int>(eventId),
      'accessoryId': serializer.toJson<int>(accessoryId),
      'strength': serializer.toJson<double?>(strength),
    };
  }

  EventAccessory copyWith({
    int? eventId,
    int? accessoryId,
    Value<double?> strength = const Value.absent(),
  }) => EventAccessory(
    eventId: eventId ?? this.eventId,
    accessoryId: accessoryId ?? this.accessoryId,
    strength: strength.present ? strength.value : this.strength,
  );
  EventAccessory copyWithCompanion(EventAccessoriesCompanion data) {
    return EventAccessory(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      accessoryId:
          data.accessoryId.present ? data.accessoryId.value : this.accessoryId,
      strength: data.strength.present ? data.strength.value : this.strength,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventAccessory(')
          ..write('eventId: $eventId, ')
          ..write('accessoryId: $accessoryId, ')
          ..write('strength: $strength')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(eventId, accessoryId, strength);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventAccessory &&
          other.eventId == this.eventId &&
          other.accessoryId == this.accessoryId &&
          other.strength == this.strength);
}

class EventAccessoriesCompanion extends UpdateCompanion<EventAccessory> {
  final Value<int> eventId;
  final Value<int> accessoryId;
  final Value<double?> strength;
  final Value<int> rowid;
  const EventAccessoriesCompanion({
    this.eventId = const Value.absent(),
    this.accessoryId = const Value.absent(),
    this.strength = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EventAccessoriesCompanion.insert({
    required int eventId,
    required int accessoryId,
    this.strength = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : eventId = Value(eventId),
       accessoryId = Value(accessoryId);
  static Insertable<EventAccessory> custom({
    Expression<int>? eventId,
    Expression<int>? accessoryId,
    Expression<double>? strength,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (accessoryId != null) 'accessory_id': accessoryId,
      if (strength != null) 'strength': strength,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EventAccessoriesCompanion copyWith({
    Value<int>? eventId,
    Value<int>? accessoryId,
    Value<double?>? strength,
    Value<int>? rowid,
  }) {
    return EventAccessoriesCompanion(
      eventId: eventId ?? this.eventId,
      accessoryId: accessoryId ?? this.accessoryId,
      strength: strength ?? this.strength,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<int>(eventId.value);
    }
    if (accessoryId.present) {
      map['accessory_id'] = Variable<int>(accessoryId.value);
    }
    if (strength.present) {
      map['strength'] = Variable<double>(strength.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventAccessoriesCompanion(')
          ..write('eventId: $eventId, ')
          ..write('accessoryId: $accessoryId, ')
          ..write('strength: $strength, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RepotEventsTable extends RepotEvents
    with TableInfo<$RepotEventsTable, RepotEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RepotEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<int> eventId = GeneratedColumn<int>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id)',
    ),
  );
  static const VerificationMeta _potSizeMeta = const VerificationMeta(
    'potSize',
  );
  @override
  late final GeneratedColumn<int> potSize = GeneratedColumn<int>(
    'pot_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _soilTypeMeta = const VerificationMeta(
    'soilType',
  );
  @override
  late final GeneratedColumn<String> soilType = GeneratedColumn<String>(
    'soil_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [eventId, potSize, soilType];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'repot_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<RepotEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('pot_size')) {
      context.handle(
        _potSizeMeta,
        potSize.isAcceptableOrUnknown(data['pot_size']!, _potSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_potSizeMeta);
    }
    if (data.containsKey('soil_type')) {
      context.handle(
        _soilTypeMeta,
        soilType.isAcceptableOrUnknown(data['soil_type']!, _soilTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_soilTypeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  RepotEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RepotEvent(
      eventId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}event_id'],
          )!,
      potSize:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}pot_size'],
          )!,
      soilType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}soil_type'],
          )!,
    );
  }

  @override
  $RepotEventsTable createAlias(String alias) {
    return $RepotEventsTable(attachedDatabase, alias);
  }
}

class RepotEvent extends DataClass implements Insertable<RepotEvent> {
  final int eventId;
  final int potSize;
  final String soilType;
  const RepotEvent({
    required this.eventId,
    required this.potSize,
    required this.soilType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<int>(eventId);
    map['pot_size'] = Variable<int>(potSize);
    map['soil_type'] = Variable<String>(soilType);
    return map;
  }

  RepotEventsCompanion toCompanion(bool nullToAbsent) {
    return RepotEventsCompanion(
      eventId: Value(eventId),
      potSize: Value(potSize),
      soilType: Value(soilType),
    );
  }

  factory RepotEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RepotEvent(
      eventId: serializer.fromJson<int>(json['eventId']),
      potSize: serializer.fromJson<int>(json['potSize']),
      soilType: serializer.fromJson<String>(json['soilType']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<int>(eventId),
      'potSize': serializer.toJson<int>(potSize),
      'soilType': serializer.toJson<String>(soilType),
    };
  }

  RepotEvent copyWith({int? eventId, int? potSize, String? soilType}) =>
      RepotEvent(
        eventId: eventId ?? this.eventId,
        potSize: potSize ?? this.potSize,
        soilType: soilType ?? this.soilType,
      );
  RepotEvent copyWithCompanion(RepotEventsCompanion data) {
    return RepotEvent(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      potSize: data.potSize.present ? data.potSize.value : this.potSize,
      soilType: data.soilType.present ? data.soilType.value : this.soilType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RepotEvent(')
          ..write('eventId: $eventId, ')
          ..write('potSize: $potSize, ')
          ..write('soilType: $soilType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(eventId, potSize, soilType);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RepotEvent &&
          other.eventId == this.eventId &&
          other.potSize == this.potSize &&
          other.soilType == this.soilType);
}

class RepotEventsCompanion extends UpdateCompanion<RepotEvent> {
  final Value<int> eventId;
  final Value<int> potSize;
  final Value<String> soilType;
  final Value<int> rowid;
  const RepotEventsCompanion({
    this.eventId = const Value.absent(),
    this.potSize = const Value.absent(),
    this.soilType = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RepotEventsCompanion.insert({
    required int eventId,
    required int potSize,
    required String soilType,
    this.rowid = const Value.absent(),
  }) : eventId = Value(eventId),
       potSize = Value(potSize),
       soilType = Value(soilType);
  static Insertable<RepotEvent> custom({
    Expression<int>? eventId,
    Expression<int>? potSize,
    Expression<String>? soilType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (potSize != null) 'pot_size': potSize,
      if (soilType != null) 'soil_type': soilType,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RepotEventsCompanion copyWith({
    Value<int>? eventId,
    Value<int>? potSize,
    Value<String>? soilType,
    Value<int>? rowid,
  }) {
    return RepotEventsCompanion(
      eventId: eventId ?? this.eventId,
      potSize: potSize ?? this.potSize,
      soilType: soilType ?? this.soilType,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<int>(eventId.value);
    }
    if (potSize.present) {
      map['pot_size'] = Variable<int>(potSize.value);
    }
    if (soilType.present) {
      map['soil_type'] = Variable<String>(soilType.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RepotEventsCompanion(')
          ..write('eventId: $eventId, ')
          ..write('potSize: $potSize, ')
          ..write('soilType: $soilType, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WaterEventsTable extends WaterEvents
    with TableInfo<$WaterEventsTable, WaterEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WaterEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<int> eventId = GeneratedColumn<int>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES events (id)',
    ),
  );
  static const VerificationMeta _timingFeedbackMeta = const VerificationMeta(
    'timingFeedback',
  );
  @override
  late final GeneratedColumn<String> timingFeedback = GeneratedColumn<String>(
    'timing_feedback',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _offsetDaysMeta = const VerificationMeta(
    'offsetDays',
  );
  @override
  late final GeneratedColumn<int> offsetDays = GeneratedColumn<int>(
    'offset_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [eventId, timingFeedback, offsetDays];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'water_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<WaterEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('timing_feedback')) {
      context.handle(
        _timingFeedbackMeta,
        timingFeedback.isAcceptableOrUnknown(
          data['timing_feedback']!,
          _timingFeedbackMeta,
        ),
      );
    }
    if (data.containsKey('offset_days')) {
      context.handle(
        _offsetDaysMeta,
        offsetDays.isAcceptableOrUnknown(data['offset_days']!, _offsetDaysMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  WaterEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WaterEvent(
      eventId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}event_id'],
          )!,
      timingFeedback: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timing_feedback'],
      ),
      offsetDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}offset_days'],
      ),
    );
  }

  @override
  $WaterEventsTable createAlias(String alias) {
    return $WaterEventsTable(attachedDatabase, alias);
  }
}

class WaterEvent extends DataClass implements Insertable<WaterEvent> {
  final int eventId;
  final String? timingFeedback;
  final int? offsetDays;
  const WaterEvent({
    required this.eventId,
    this.timingFeedback,
    this.offsetDays,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['event_id'] = Variable<int>(eventId);
    if (!nullToAbsent || timingFeedback != null) {
      map['timing_feedback'] = Variable<String>(timingFeedback);
    }
    if (!nullToAbsent || offsetDays != null) {
      map['offset_days'] = Variable<int>(offsetDays);
    }
    return map;
  }

  WaterEventsCompanion toCompanion(bool nullToAbsent) {
    return WaterEventsCompanion(
      eventId: Value(eventId),
      timingFeedback:
          timingFeedback == null && nullToAbsent
              ? const Value.absent()
              : Value(timingFeedback),
      offsetDays:
          offsetDays == null && nullToAbsent
              ? const Value.absent()
              : Value(offsetDays),
    );
  }

  factory WaterEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WaterEvent(
      eventId: serializer.fromJson<int>(json['eventId']),
      timingFeedback: serializer.fromJson<String?>(json['timingFeedback']),
      offsetDays: serializer.fromJson<int?>(json['offsetDays']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'eventId': serializer.toJson<int>(eventId),
      'timingFeedback': serializer.toJson<String?>(timingFeedback),
      'offsetDays': serializer.toJson<int?>(offsetDays),
    };
  }

  WaterEvent copyWith({
    int? eventId,
    Value<String?> timingFeedback = const Value.absent(),
    Value<int?> offsetDays = const Value.absent(),
  }) => WaterEvent(
    eventId: eventId ?? this.eventId,
    timingFeedback:
        timingFeedback.present ? timingFeedback.value : this.timingFeedback,
    offsetDays: offsetDays.present ? offsetDays.value : this.offsetDays,
  );
  WaterEvent copyWithCompanion(WaterEventsCompanion data) {
    return WaterEvent(
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      timingFeedback:
          data.timingFeedback.present
              ? data.timingFeedback.value
              : this.timingFeedback,
      offsetDays:
          data.offsetDays.present ? data.offsetDays.value : this.offsetDays,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WaterEvent(')
          ..write('eventId: $eventId, ')
          ..write('timingFeedback: $timingFeedback, ')
          ..write('offsetDays: $offsetDays')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(eventId, timingFeedback, offsetDays);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WaterEvent &&
          other.eventId == this.eventId &&
          other.timingFeedback == this.timingFeedback &&
          other.offsetDays == this.offsetDays);
}

class WaterEventsCompanion extends UpdateCompanion<WaterEvent> {
  final Value<int> eventId;
  final Value<String?> timingFeedback;
  final Value<int?> offsetDays;
  final Value<int> rowid;
  const WaterEventsCompanion({
    this.eventId = const Value.absent(),
    this.timingFeedback = const Value.absent(),
    this.offsetDays = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WaterEventsCompanion.insert({
    required int eventId,
    this.timingFeedback = const Value.absent(),
    this.offsetDays = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : eventId = Value(eventId);
  static Insertable<WaterEvent> custom({
    Expression<int>? eventId,
    Expression<String>? timingFeedback,
    Expression<int>? offsetDays,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (eventId != null) 'event_id': eventId,
      if (timingFeedback != null) 'timing_feedback': timingFeedback,
      if (offsetDays != null) 'offset_days': offsetDays,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WaterEventsCompanion copyWith({
    Value<int>? eventId,
    Value<String?>? timingFeedback,
    Value<int?>? offsetDays,
    Value<int>? rowid,
  }) {
    return WaterEventsCompanion(
      eventId: eventId ?? this.eventId,
      timingFeedback: timingFeedback ?? this.timingFeedback,
      offsetDays: offsetDays ?? this.offsetDays,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (eventId.present) {
      map['event_id'] = Variable<int>(eventId.value);
    }
    if (timingFeedback.present) {
      map['timing_feedback'] = Variable<String>(timingFeedback.value);
    }
    if (offsetDays.present) {
      map['offset_days'] = Variable<int>(offsetDays.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WaterEventsCompanion(')
          ..write('eventId: $eventId, ')
          ..write('timingFeedback: $timingFeedback, ')
          ..write('offsetDays: $offsetDays, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PhotosTable extends Photos with TableInfo<$PhotosTable, Photo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _plantIdMeta = const VerificationMeta(
    'plantId',
  );
  @override
  late final GeneratedColumn<int> plantId = GeneratedColumn<int>(
    'plant_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plants (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, plantId, date, filePath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Photo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plant_id')) {
      context.handle(
        _plantIdMeta,
        plantId.isAcceptableOrUnknown(data['plant_id']!, _plantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_plantIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Photo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Photo(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      plantId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}plant_id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}date'],
          )!,
      filePath:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}file_path'],
          )!,
    );
  }

  @override
  $PhotosTable createAlias(String alias) {
    return $PhotosTable(attachedDatabase, alias);
  }
}

class Photo extends DataClass implements Insertable<Photo> {
  final int id;
  final int plantId;
  final String date;
  final String filePath;
  const Photo({
    required this.id,
    required this.plantId,
    required this.date,
    required this.filePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plant_id'] = Variable<int>(plantId);
    map['date'] = Variable<String>(date);
    map['file_path'] = Variable<String>(filePath);
    return map;
  }

  PhotosCompanion toCompanion(bool nullToAbsent) {
    return PhotosCompanion(
      id: Value(id),
      plantId: Value(plantId),
      date: Value(date),
      filePath: Value(filePath),
    );
  }

  factory Photo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Photo(
      id: serializer.fromJson<int>(json['id']),
      plantId: serializer.fromJson<int>(json['plantId']),
      date: serializer.fromJson<String>(json['date']),
      filePath: serializer.fromJson<String>(json['filePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'plantId': serializer.toJson<int>(plantId),
      'date': serializer.toJson<String>(date),
      'filePath': serializer.toJson<String>(filePath),
    };
  }

  Photo copyWith({int? id, int? plantId, String? date, String? filePath}) =>
      Photo(
        id: id ?? this.id,
        plantId: plantId ?? this.plantId,
        date: date ?? this.date,
        filePath: filePath ?? this.filePath,
      );
  Photo copyWithCompanion(PhotosCompanion data) {
    return Photo(
      id: data.id.present ? data.id.value : this.id,
      plantId: data.plantId.present ? data.plantId.value : this.plantId,
      date: data.date.present ? data.date.value : this.date,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Photo(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('date: $date, ')
          ..write('filePath: $filePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, plantId, date, filePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Photo &&
          other.id == this.id &&
          other.plantId == this.plantId &&
          other.date == this.date &&
          other.filePath == this.filePath);
}

class PhotosCompanion extends UpdateCompanion<Photo> {
  final Value<int> id;
  final Value<int> plantId;
  final Value<String> date;
  final Value<String> filePath;
  const PhotosCompanion({
    this.id = const Value.absent(),
    this.plantId = const Value.absent(),
    this.date = const Value.absent(),
    this.filePath = const Value.absent(),
  });
  PhotosCompanion.insert({
    this.id = const Value.absent(),
    required int plantId,
    required String date,
    required String filePath,
  }) : plantId = Value(plantId),
       date = Value(date),
       filePath = Value(filePath);
  static Insertable<Photo> custom({
    Expression<int>? id,
    Expression<int>? plantId,
    Expression<String>? date,
    Expression<String>? filePath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plantId != null) 'plant_id': plantId,
      if (date != null) 'date': date,
      if (filePath != null) 'file_path': filePath,
    });
  }

  PhotosCompanion copyWith({
    Value<int>? id,
    Value<int>? plantId,
    Value<String>? date,
    Value<String>? filePath,
  }) {
    return PhotosCompanion(
      id: id ?? this.id,
      plantId: plantId ?? this.plantId,
      date: date ?? this.date,
      filePath: filePath ?? this.filePath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (plantId.present) {
      map['plant_id'] = Variable<int>(plantId.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PhotosCompanion(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('date: $date, ')
          ..write('filePath: $filePath')
          ..write(')'))
        .toString();
  }
}

abstract class _$PlantAppDb extends GeneratedDatabase {
  _$PlantAppDb(QueryExecutor e) : super(e);
  $PlantAppDbManager get managers => $PlantAppDbManager(this);
  late final $PlantsTable plants = $PlantsTable(this);
  late final $AccessoriesTable accessories = $AccessoriesTable(this);
  late final $EventsTable events = $EventsTable(this);
  late final $EventAccessoriesTable eventAccessories = $EventAccessoriesTable(
    this,
  );
  late final $RepotEventsTable repotEvents = $RepotEventsTable(this);
  late final $WaterEventsTable waterEvents = $WaterEventsTable(this);
  late final $PhotosTable photos = $PhotosTable(this);
  late final PlantsDao plantsDao = PlantsDao(this as PlantAppDb);
  late final EventsDao eventsDao = EventsDao(this as PlantAppDb);
  late final PhotosDao photosDao = PhotosDao(this as PlantAppDb);
  late final AccessoriesDao accessoriesDao = AccessoriesDao(this as PlantAppDb);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    plants,
    accessories,
    events,
    eventAccessories,
    repotEvents,
    waterEvents,
    photos,
  ];
}

typedef $$PlantsTableCreateCompanionBuilder =
    PlantsCompanion Function({
      Value<int> id,
      required String name,
      required bool inWateringSchedule,
      Value<String?> notes,
      required String dateAdded,
      Value<double?> minWateringDays,
      Value<double?> maxWateringDays,
      Value<int> totalFeedback,
      Value<int> positiveFeedback,
    });
typedef $$PlantsTableUpdateCompanionBuilder =
    PlantsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> inWateringSchedule,
      Value<String?> notes,
      Value<String> dateAdded,
      Value<double?> minWateringDays,
      Value<double?> maxWateringDays,
      Value<int> totalFeedback,
      Value<int> positiveFeedback,
    });

final class $$PlantsTableReferences
    extends BaseReferences<_$PlantAppDb, $PlantsTable, Plant> {
  $$PlantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EventsTable, List<Event>> _eventsRefsTable(
    _$PlantAppDb db,
  ) => MultiTypedResultKey.fromTable(
    db.events,
    aliasName: $_aliasNameGenerator(db.plants.id, db.events.plantId),
  );

  $$EventsTableProcessedTableManager get eventsRefs {
    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.plantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PhotosTable, List<Photo>> _photosRefsTable(
    _$PlantAppDb db,
  ) => MultiTypedResultKey.fromTable(
    db.photos,
    aliasName: $_aliasNameGenerator(db.plants.id, db.photos.plantId),
  );

  $$PhotosTableProcessedTableManager get photosRefs {
    final manager = $$PhotosTableTableManager(
      $_db,
      $_db.photos,
    ).filter((f) => f.plantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_photosRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlantsTableFilterComposer extends Composer<_$PlantAppDb, $PlantsTable> {
  $$PlantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get inWateringSchedule => $composableBuilder(
    column: $table.inWateringSchedule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minWateringDays => $composableBuilder(
    column: $table.minWateringDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get maxWateringDays => $composableBuilder(
    column: $table.maxWateringDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalFeedback => $composableBuilder(
    column: $table.totalFeedback,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get positiveFeedback => $composableBuilder(
    column: $table.positiveFeedback,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> eventsRefs(
    Expression<bool> Function($$EventsTableFilterComposer f) f,
  ) {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.plantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> photosRefs(
    Expression<bool> Function($$PhotosTableFilterComposer f) f,
  ) {
    final $$PhotosTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.plantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableFilterComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlantsTableOrderingComposer
    extends Composer<_$PlantAppDb, $PlantsTable> {
  $$PlantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get inWateringSchedule => $composableBuilder(
    column: $table.inWateringSchedule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateAdded => $composableBuilder(
    column: $table.dateAdded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minWateringDays => $composableBuilder(
    column: $table.minWateringDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get maxWateringDays => $composableBuilder(
    column: $table.maxWateringDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalFeedback => $composableBuilder(
    column: $table.totalFeedback,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get positiveFeedback => $composableBuilder(
    column: $table.positiveFeedback,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlantsTableAnnotationComposer
    extends Composer<_$PlantAppDb, $PlantsTable> {
  $$PlantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get inWateringSchedule => $composableBuilder(
    column: $table.inWateringSchedule,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get dateAdded =>
      $composableBuilder(column: $table.dateAdded, builder: (column) => column);

  GeneratedColumn<double> get minWateringDays => $composableBuilder(
    column: $table.minWateringDays,
    builder: (column) => column,
  );

  GeneratedColumn<double> get maxWateringDays => $composableBuilder(
    column: $table.maxWateringDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalFeedback => $composableBuilder(
    column: $table.totalFeedback,
    builder: (column) => column,
  );

  GeneratedColumn<int> get positiveFeedback => $composableBuilder(
    column: $table.positiveFeedback,
    builder: (column) => column,
  );

  Expression<T> eventsRefs<T extends Object>(
    Expression<T> Function($$EventsTableAnnotationComposer a) f,
  ) {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.plantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> photosRefs<T extends Object>(
    Expression<T> Function($$PhotosTableAnnotationComposer a) f,
  ) {
    final $$PhotosTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.photos,
      getReferencedColumn: (t) => t.plantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PhotosTableAnnotationComposer(
            $db: $db,
            $table: $db.photos,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlantsTableTableManager
    extends
        RootTableManager<
          _$PlantAppDb,
          $PlantsTable,
          Plant,
          $$PlantsTableFilterComposer,
          $$PlantsTableOrderingComposer,
          $$PlantsTableAnnotationComposer,
          $$PlantsTableCreateCompanionBuilder,
          $$PlantsTableUpdateCompanionBuilder,
          (Plant, $$PlantsTableReferences),
          Plant,
          PrefetchHooks Function({bool eventsRefs, bool photosRefs})
        > {
  $$PlantsTableTableManager(_$PlantAppDb db, $PlantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PlantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PlantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PlantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> inWateringSchedule = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> dateAdded = const Value.absent(),
                Value<double?> minWateringDays = const Value.absent(),
                Value<double?> maxWateringDays = const Value.absent(),
                Value<int> totalFeedback = const Value.absent(),
                Value<int> positiveFeedback = const Value.absent(),
              }) => PlantsCompanion(
                id: id,
                name: name,
                inWateringSchedule: inWateringSchedule,
                notes: notes,
                dateAdded: dateAdded,
                minWateringDays: minWateringDays,
                maxWateringDays: maxWateringDays,
                totalFeedback: totalFeedback,
                positiveFeedback: positiveFeedback,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required bool inWateringSchedule,
                Value<String?> notes = const Value.absent(),
                required String dateAdded,
                Value<double?> minWateringDays = const Value.absent(),
                Value<double?> maxWateringDays = const Value.absent(),
                Value<int> totalFeedback = const Value.absent(),
                Value<int> positiveFeedback = const Value.absent(),
              }) => PlantsCompanion.insert(
                id: id,
                name: name,
                inWateringSchedule: inWateringSchedule,
                notes: notes,
                dateAdded: dateAdded,
                minWateringDays: minWateringDays,
                maxWateringDays: maxWateringDays,
                totalFeedback: totalFeedback,
                positiveFeedback: positiveFeedback,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$PlantsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({eventsRefs = false, photosRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (eventsRefs) db.events,
                if (photosRefs) db.photos,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (eventsRefs)
                    await $_getPrefetchedData<Plant, $PlantsTable, Event>(
                      currentTable: table,
                      referencedTable: $$PlantsTableReferences._eventsRefsTable(
                        db,
                      ),
                      managerFromTypedResult:
                          (p0) =>
                              $$PlantsTableReferences(db, table, p0).eventsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.plantId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (photosRefs)
                    await $_getPrefetchedData<Plant, $PlantsTable, Photo>(
                      currentTable: table,
                      referencedTable: $$PlantsTableReferences._photosRefsTable(
                        db,
                      ),
                      managerFromTypedResult:
                          (p0) =>
                              $$PlantsTableReferences(db, table, p0).photosRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.plantId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PlantsTableProcessedTableManager =
    ProcessedTableManager<
      _$PlantAppDb,
      $PlantsTable,
      Plant,
      $$PlantsTableFilterComposer,
      $$PlantsTableOrderingComposer,
      $$PlantsTableAnnotationComposer,
      $$PlantsTableCreateCompanionBuilder,
      $$PlantsTableUpdateCompanionBuilder,
      (Plant, $$PlantsTableReferences),
      Plant,
      PrefetchHooks Function({bool eventsRefs, bool photosRefs})
    >;
typedef $$AccessoriesTableCreateCompanionBuilder =
    AccessoriesCompanion Function({
      Value<int> id,
      required String type,
      required String name,
      Value<String?> notes,
      Value<bool> isActive,
    });
typedef $$AccessoriesTableUpdateCompanionBuilder =
    AccessoriesCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<String> name,
      Value<String?> notes,
      Value<bool> isActive,
    });

final class $$AccessoriesTableReferences
    extends BaseReferences<_$PlantAppDb, $AccessoriesTable, Accessory> {
  $$AccessoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EventAccessoriesTable, List<EventAccessory>>
  _eventAccessoriesRefsTable(_$PlantAppDb db) => MultiTypedResultKey.fromTable(
    db.eventAccessories,
    aliasName: $_aliasNameGenerator(
      db.accessories.id,
      db.eventAccessories.accessoryId,
    ),
  );

  $$EventAccessoriesTableProcessedTableManager get eventAccessoriesRefs {
    final manager = $$EventAccessoriesTableTableManager(
      $_db,
      $_db.eventAccessories,
    ).filter((f) => f.accessoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _eventAccessoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccessoriesTableFilterComposer
    extends Composer<_$PlantAppDb, $AccessoriesTable> {
  $$AccessoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> eventAccessoriesRefs(
    Expression<bool> Function($$EventAccessoriesTableFilterComposer f) f,
  ) {
    final $$EventAccessoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventAccessories,
      getReferencedColumn: (t) => t.accessoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventAccessoriesTableFilterComposer(
            $db: $db,
            $table: $db.eventAccessories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccessoriesTableOrderingComposer
    extends Composer<_$PlantAppDb, $AccessoriesTable> {
  $$AccessoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccessoriesTableAnnotationComposer
    extends Composer<_$PlantAppDb, $AccessoriesTable> {
  $$AccessoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> eventAccessoriesRefs<T extends Object>(
    Expression<T> Function($$EventAccessoriesTableAnnotationComposer a) f,
  ) {
    final $$EventAccessoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventAccessories,
      getReferencedColumn: (t) => t.accessoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventAccessoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.eventAccessories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccessoriesTableTableManager
    extends
        RootTableManager<
          _$PlantAppDb,
          $AccessoriesTable,
          Accessory,
          $$AccessoriesTableFilterComposer,
          $$AccessoriesTableOrderingComposer,
          $$AccessoriesTableAnnotationComposer,
          $$AccessoriesTableCreateCompanionBuilder,
          $$AccessoriesTableUpdateCompanionBuilder,
          (Accessory, $$AccessoriesTableReferences),
          Accessory,
          PrefetchHooks Function({bool eventAccessoriesRefs})
        > {
  $$AccessoriesTableTableManager(_$PlantAppDb db, $AccessoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$AccessoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$AccessoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$AccessoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => AccessoriesCompanion(
                id: id,
                type: type,
                name: name,
                notes: notes,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required String name,
                Value<String?> notes = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => AccessoriesCompanion.insert(
                id: id,
                type: type,
                name: name,
                notes: notes,
                isActive: isActive,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$AccessoriesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({eventAccessoriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (eventAccessoriesRefs) db.eventAccessories,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (eventAccessoriesRefs)
                    await $_getPrefetchedData<
                      Accessory,
                      $AccessoriesTable,
                      EventAccessory
                    >(
                      currentTable: table,
                      referencedTable: $$AccessoriesTableReferences
                          ._eventAccessoriesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$AccessoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).eventAccessoriesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.accessoryId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$AccessoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$PlantAppDb,
      $AccessoriesTable,
      Accessory,
      $$AccessoriesTableFilterComposer,
      $$AccessoriesTableOrderingComposer,
      $$AccessoriesTableAnnotationComposer,
      $$AccessoriesTableCreateCompanionBuilder,
      $$AccessoriesTableUpdateCompanionBuilder,
      (Accessory, $$AccessoriesTableReferences),
      Accessory,
      PrefetchHooks Function({bool eventAccessoriesRefs})
    >;
typedef $$EventsTableCreateCompanionBuilder =
    EventsCompanion Function({
      Value<int> id,
      required int plantId,
      required String eventType,
      required String date,
      Value<String?> notes,
    });
typedef $$EventsTableUpdateCompanionBuilder =
    EventsCompanion Function({
      Value<int> id,
      Value<int> plantId,
      Value<String> eventType,
      Value<String> date,
      Value<String?> notes,
    });

final class $$EventsTableReferences
    extends BaseReferences<_$PlantAppDb, $EventsTable, Event> {
  $$EventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlantsTable _plantIdTable(_$PlantAppDb db) => db.plants.createAlias(
    $_aliasNameGenerator(db.events.plantId, db.plants.id),
  );

  $$PlantsTableProcessedTableManager get plantId {
    final $_column = $_itemColumn<int>('plant_id')!;

    final manager = $$PlantsTableTableManager(
      $_db,
      $_db.plants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_plantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EventAccessoriesTable, List<EventAccessory>>
  _eventAccessoriesRefsTable(_$PlantAppDb db) => MultiTypedResultKey.fromTable(
    db.eventAccessories,
    aliasName: $_aliasNameGenerator(db.events.id, db.eventAccessories.eventId),
  );

  $$EventAccessoriesTableProcessedTableManager get eventAccessoriesRefs {
    final manager = $$EventAccessoriesTableTableManager(
      $_db,
      $_db.eventAccessories,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _eventAccessoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RepotEventsTable, List<RepotEvent>>
  _repotEventsRefsTable(_$PlantAppDb db) => MultiTypedResultKey.fromTable(
    db.repotEvents,
    aliasName: $_aliasNameGenerator(db.events.id, db.repotEvents.eventId),
  );

  $$RepotEventsTableProcessedTableManager get repotEventsRefs {
    final manager = $$RepotEventsTableTableManager(
      $_db,
      $_db.repotEvents,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_repotEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WaterEventsTable, List<WaterEvent>>
  _waterEventsRefsTable(_$PlantAppDb db) => MultiTypedResultKey.fromTable(
    db.waterEvents,
    aliasName: $_aliasNameGenerator(db.events.id, db.waterEvents.eventId),
  );

  $$WaterEventsTableProcessedTableManager get waterEventsRefs {
    final manager = $$WaterEventsTableTableManager(
      $_db,
      $_db.waterEvents,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_waterEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EventsTableFilterComposer extends Composer<_$PlantAppDb, $EventsTable> {
  $$EventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$PlantsTableFilterComposer get plantId {
    final $$PlantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plantId,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableFilterComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> eventAccessoriesRefs(
    Expression<bool> Function($$EventAccessoriesTableFilterComposer f) f,
  ) {
    final $$EventAccessoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventAccessories,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventAccessoriesTableFilterComposer(
            $db: $db,
            $table: $db.eventAccessories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> repotEventsRefs(
    Expression<bool> Function($$RepotEventsTableFilterComposer f) f,
  ) {
    final $$RepotEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repotEvents,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepotEventsTableFilterComposer(
            $db: $db,
            $table: $db.repotEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> waterEventsRefs(
    Expression<bool> Function($$WaterEventsTableFilterComposer f) f,
  ) {
    final $$WaterEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.waterEvents,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WaterEventsTableFilterComposer(
            $db: $db,
            $table: $db.waterEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EventsTableOrderingComposer
    extends Composer<_$PlantAppDb, $EventsTable> {
  $$EventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventType => $composableBuilder(
    column: $table.eventType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlantsTableOrderingComposer get plantId {
    final $$PlantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plantId,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableOrderingComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventsTableAnnotationComposer
    extends Composer<_$PlantAppDb, $EventsTable> {
  $$EventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventType =>
      $composableBuilder(column: $table.eventType, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$PlantsTableAnnotationComposer get plantId {
    final $$PlantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plantId,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableAnnotationComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> eventAccessoriesRefs<T extends Object>(
    Expression<T> Function($$EventAccessoriesTableAnnotationComposer a) f,
  ) {
    final $$EventAccessoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventAccessories,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventAccessoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.eventAccessories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> repotEventsRefs<T extends Object>(
    Expression<T> Function($$RepotEventsTableAnnotationComposer a) f,
  ) {
    final $$RepotEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.repotEvents,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RepotEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.repotEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> waterEventsRefs<T extends Object>(
    Expression<T> Function($$WaterEventsTableAnnotationComposer a) f,
  ) {
    final $$WaterEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.waterEvents,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WaterEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.waterEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EventsTableTableManager
    extends
        RootTableManager<
          _$PlantAppDb,
          $EventsTable,
          Event,
          $$EventsTableFilterComposer,
          $$EventsTableOrderingComposer,
          $$EventsTableAnnotationComposer,
          $$EventsTableCreateCompanionBuilder,
          $$EventsTableUpdateCompanionBuilder,
          (Event, $$EventsTableReferences),
          Event,
          PrefetchHooks Function({
            bool plantId,
            bool eventAccessoriesRefs,
            bool repotEventsRefs,
            bool waterEventsRefs,
          })
        > {
  $$EventsTableTableManager(_$PlantAppDb db, $EventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$EventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$EventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$EventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> plantId = const Value.absent(),
                Value<String> eventType = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => EventsCompanion(
                id: id,
                plantId: plantId,
                eventType: eventType,
                date: date,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int plantId,
                required String eventType,
                required String date,
                Value<String?> notes = const Value.absent(),
              }) => EventsCompanion.insert(
                id: id,
                plantId: plantId,
                eventType: eventType,
                date: date,
                notes: notes,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$EventsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            plantId = false,
            eventAccessoriesRefs = false,
            repotEventsRefs = false,
            waterEventsRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (eventAccessoriesRefs) db.eventAccessories,
                if (repotEventsRefs) db.repotEvents,
                if (waterEventsRefs) db.waterEvents,
              ],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (plantId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.plantId,
                            referencedTable: $$EventsTableReferences
                                ._plantIdTable(db),
                            referencedColumn:
                                $$EventsTableReferences._plantIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (eventAccessoriesRefs)
                    await $_getPrefetchedData<
                      Event,
                      $EventsTable,
                      EventAccessory
                    >(
                      currentTable: table,
                      referencedTable: $$EventsTableReferences
                          ._eventAccessoriesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$EventsTableReferences(
                                db,
                                table,
                                p0,
                              ).eventAccessoriesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.eventId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (repotEventsRefs)
                    await $_getPrefetchedData<Event, $EventsTable, RepotEvent>(
                      currentTable: table,
                      referencedTable: $$EventsTableReferences
                          ._repotEventsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$EventsTableReferences(
                                db,
                                table,
                                p0,
                              ).repotEventsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.eventId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (waterEventsRefs)
                    await $_getPrefetchedData<Event, $EventsTable, WaterEvent>(
                      currentTable: table,
                      referencedTable: $$EventsTableReferences
                          ._waterEventsRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$EventsTableReferences(
                                db,
                                table,
                                p0,
                              ).waterEventsRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.eventId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EventsTableProcessedTableManager =
    ProcessedTableManager<
      _$PlantAppDb,
      $EventsTable,
      Event,
      $$EventsTableFilterComposer,
      $$EventsTableOrderingComposer,
      $$EventsTableAnnotationComposer,
      $$EventsTableCreateCompanionBuilder,
      $$EventsTableUpdateCompanionBuilder,
      (Event, $$EventsTableReferences),
      Event,
      PrefetchHooks Function({
        bool plantId,
        bool eventAccessoriesRefs,
        bool repotEventsRefs,
        bool waterEventsRefs,
      })
    >;
typedef $$EventAccessoriesTableCreateCompanionBuilder =
    EventAccessoriesCompanion Function({
      required int eventId,
      required int accessoryId,
      Value<double?> strength,
      Value<int> rowid,
    });
typedef $$EventAccessoriesTableUpdateCompanionBuilder =
    EventAccessoriesCompanion Function({
      Value<int> eventId,
      Value<int> accessoryId,
      Value<double?> strength,
      Value<int> rowid,
    });

final class $$EventAccessoriesTableReferences
    extends
        BaseReferences<_$PlantAppDb, $EventAccessoriesTable, EventAccessory> {
  $$EventAccessoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $EventsTable _eventIdTable(_$PlantAppDb db) => db.events.createAlias(
    $_aliasNameGenerator(db.eventAccessories.eventId, db.events.id),
  );

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<int>('event_id')!;

    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccessoriesTable _accessoryIdTable(_$PlantAppDb db) =>
      db.accessories.createAlias(
        $_aliasNameGenerator(
          db.eventAccessories.accessoryId,
          db.accessories.id,
        ),
      );

  $$AccessoriesTableProcessedTableManager get accessoryId {
    final $_column = $_itemColumn<int>('accessory_id')!;

    final manager = $$AccessoriesTableTableManager(
      $_db,
      $_db.accessories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accessoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EventAccessoriesTableFilterComposer
    extends Composer<_$PlantAppDb, $EventAccessoriesTable> {
  $$EventAccessoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnFilters(column),
  );

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccessoriesTableFilterComposer get accessoryId {
    final $$AccessoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accessoryId,
      referencedTable: $db.accessories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccessoriesTableFilterComposer(
            $db: $db,
            $table: $db.accessories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventAccessoriesTableOrderingComposer
    extends Composer<_$PlantAppDb, $EventAccessoriesTable> {
  $$EventAccessoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccessoriesTableOrderingComposer get accessoryId {
    final $$AccessoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accessoryId,
      referencedTable: $db.accessories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccessoriesTableOrderingComposer(
            $db: $db,
            $table: $db.accessories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventAccessoriesTableAnnotationComposer
    extends Composer<_$PlantAppDb, $EventAccessoriesTable> {
  $$EventAccessoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccessoriesTableAnnotationComposer get accessoryId {
    final $$AccessoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accessoryId,
      referencedTable: $db.accessories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccessoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.accessories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventAccessoriesTableTableManager
    extends
        RootTableManager<
          _$PlantAppDb,
          $EventAccessoriesTable,
          EventAccessory,
          $$EventAccessoriesTableFilterComposer,
          $$EventAccessoriesTableOrderingComposer,
          $$EventAccessoriesTableAnnotationComposer,
          $$EventAccessoriesTableCreateCompanionBuilder,
          $$EventAccessoriesTableUpdateCompanionBuilder,
          (EventAccessory, $$EventAccessoriesTableReferences),
          EventAccessory,
          PrefetchHooks Function({bool eventId, bool accessoryId})
        > {
  $$EventAccessoriesTableTableManager(
    _$PlantAppDb db,
    $EventAccessoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$EventAccessoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$EventAccessoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$EventAccessoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> eventId = const Value.absent(),
                Value<int> accessoryId = const Value.absent(),
                Value<double?> strength = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventAccessoriesCompanion(
                eventId: eventId,
                accessoryId: accessoryId,
                strength: strength,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int eventId,
                required int accessoryId,
                Value<double?> strength = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EventAccessoriesCompanion.insert(
                eventId: eventId,
                accessoryId: accessoryId,
                strength: strength,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$EventAccessoriesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({eventId = false, accessoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (eventId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.eventId,
                            referencedTable: $$EventAccessoriesTableReferences
                                ._eventIdTable(db),
                            referencedColumn:
                                $$EventAccessoriesTableReferences
                                    ._eventIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (accessoryId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.accessoryId,
                            referencedTable: $$EventAccessoriesTableReferences
                                ._accessoryIdTable(db),
                            referencedColumn:
                                $$EventAccessoriesTableReferences
                                    ._accessoryIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$EventAccessoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$PlantAppDb,
      $EventAccessoriesTable,
      EventAccessory,
      $$EventAccessoriesTableFilterComposer,
      $$EventAccessoriesTableOrderingComposer,
      $$EventAccessoriesTableAnnotationComposer,
      $$EventAccessoriesTableCreateCompanionBuilder,
      $$EventAccessoriesTableUpdateCompanionBuilder,
      (EventAccessory, $$EventAccessoriesTableReferences),
      EventAccessory,
      PrefetchHooks Function({bool eventId, bool accessoryId})
    >;
typedef $$RepotEventsTableCreateCompanionBuilder =
    RepotEventsCompanion Function({
      required int eventId,
      required int potSize,
      required String soilType,
      Value<int> rowid,
    });
typedef $$RepotEventsTableUpdateCompanionBuilder =
    RepotEventsCompanion Function({
      Value<int> eventId,
      Value<int> potSize,
      Value<String> soilType,
      Value<int> rowid,
    });

final class $$RepotEventsTableReferences
    extends BaseReferences<_$PlantAppDb, $RepotEventsTable, RepotEvent> {
  $$RepotEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventIdTable(_$PlantAppDb db) => db.events.createAlias(
    $_aliasNameGenerator(db.repotEvents.eventId, db.events.id),
  );

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<int>('event_id')!;

    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RepotEventsTableFilterComposer
    extends Composer<_$PlantAppDb, $RepotEventsTable> {
  $$RepotEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get potSize => $composableBuilder(
    column: $table.potSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get soilType => $composableBuilder(
    column: $table.soilType,
    builder: (column) => ColumnFilters(column),
  );

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepotEventsTableOrderingComposer
    extends Composer<_$PlantAppDb, $RepotEventsTable> {
  $$RepotEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get potSize => $composableBuilder(
    column: $table.potSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get soilType => $composableBuilder(
    column: $table.soilType,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepotEventsTableAnnotationComposer
    extends Composer<_$PlantAppDb, $RepotEventsTable> {
  $$RepotEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get potSize =>
      $composableBuilder(column: $table.potSize, builder: (column) => column);

  GeneratedColumn<String> get soilType =>
      $composableBuilder(column: $table.soilType, builder: (column) => column);

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RepotEventsTableTableManager
    extends
        RootTableManager<
          _$PlantAppDb,
          $RepotEventsTable,
          RepotEvent,
          $$RepotEventsTableFilterComposer,
          $$RepotEventsTableOrderingComposer,
          $$RepotEventsTableAnnotationComposer,
          $$RepotEventsTableCreateCompanionBuilder,
          $$RepotEventsTableUpdateCompanionBuilder,
          (RepotEvent, $$RepotEventsTableReferences),
          RepotEvent,
          PrefetchHooks Function({bool eventId})
        > {
  $$RepotEventsTableTableManager(_$PlantAppDb db, $RepotEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$RepotEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$RepotEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$RepotEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> eventId = const Value.absent(),
                Value<int> potSize = const Value.absent(),
                Value<String> soilType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RepotEventsCompanion(
                eventId: eventId,
                potSize: potSize,
                soilType: soilType,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int eventId,
                required int potSize,
                required String soilType,
                Value<int> rowid = const Value.absent(),
              }) => RepotEventsCompanion.insert(
                eventId: eventId,
                potSize: potSize,
                soilType: soilType,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$RepotEventsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({eventId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (eventId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.eventId,
                            referencedTable: $$RepotEventsTableReferences
                                ._eventIdTable(db),
                            referencedColumn:
                                $$RepotEventsTableReferences
                                    ._eventIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RepotEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$PlantAppDb,
      $RepotEventsTable,
      RepotEvent,
      $$RepotEventsTableFilterComposer,
      $$RepotEventsTableOrderingComposer,
      $$RepotEventsTableAnnotationComposer,
      $$RepotEventsTableCreateCompanionBuilder,
      $$RepotEventsTableUpdateCompanionBuilder,
      (RepotEvent, $$RepotEventsTableReferences),
      RepotEvent,
      PrefetchHooks Function({bool eventId})
    >;
typedef $$WaterEventsTableCreateCompanionBuilder =
    WaterEventsCompanion Function({
      required int eventId,
      Value<String?> timingFeedback,
      Value<int?> offsetDays,
      Value<int> rowid,
    });
typedef $$WaterEventsTableUpdateCompanionBuilder =
    WaterEventsCompanion Function({
      Value<int> eventId,
      Value<String?> timingFeedback,
      Value<int?> offsetDays,
      Value<int> rowid,
    });

final class $$WaterEventsTableReferences
    extends BaseReferences<_$PlantAppDb, $WaterEventsTable, WaterEvent> {
  $$WaterEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventsTable _eventIdTable(_$PlantAppDb db) => db.events.createAlias(
    $_aliasNameGenerator(db.waterEvents.eventId, db.events.id),
  );

  $$EventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<int>('event_id')!;

    final manager = $$EventsTableTableManager(
      $_db,
      $_db.events,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WaterEventsTableFilterComposer
    extends Composer<_$PlantAppDb, $WaterEventsTable> {
  $$WaterEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get timingFeedback => $composableBuilder(
    column: $table.timingFeedback,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get offsetDays => $composableBuilder(
    column: $table.offsetDays,
    builder: (column) => ColumnFilters(column),
  );

  $$EventsTableFilterComposer get eventId {
    final $$EventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableFilterComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WaterEventsTableOrderingComposer
    extends Composer<_$PlantAppDb, $WaterEventsTable> {
  $$WaterEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get timingFeedback => $composableBuilder(
    column: $table.timingFeedback,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get offsetDays => $composableBuilder(
    column: $table.offsetDays,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventsTableOrderingComposer get eventId {
    final $$EventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableOrderingComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WaterEventsTableAnnotationComposer
    extends Composer<_$PlantAppDb, $WaterEventsTable> {
  $$WaterEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get timingFeedback => $composableBuilder(
    column: $table.timingFeedback,
    builder: (column) => column,
  );

  GeneratedColumn<int> get offsetDays => $composableBuilder(
    column: $table.offsetDays,
    builder: (column) => column,
  );

  $$EventsTableAnnotationComposer get eventId {
    final $$EventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.events,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventsTableAnnotationComposer(
            $db: $db,
            $table: $db.events,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WaterEventsTableTableManager
    extends
        RootTableManager<
          _$PlantAppDb,
          $WaterEventsTable,
          WaterEvent,
          $$WaterEventsTableFilterComposer,
          $$WaterEventsTableOrderingComposer,
          $$WaterEventsTableAnnotationComposer,
          $$WaterEventsTableCreateCompanionBuilder,
          $$WaterEventsTableUpdateCompanionBuilder,
          (WaterEvent, $$WaterEventsTableReferences),
          WaterEvent,
          PrefetchHooks Function({bool eventId})
        > {
  $$WaterEventsTableTableManager(_$PlantAppDb db, $WaterEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$WaterEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$WaterEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$WaterEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> eventId = const Value.absent(),
                Value<String?> timingFeedback = const Value.absent(),
                Value<int?> offsetDays = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WaterEventsCompanion(
                eventId: eventId,
                timingFeedback: timingFeedback,
                offsetDays: offsetDays,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int eventId,
                Value<String?> timingFeedback = const Value.absent(),
                Value<int?> offsetDays = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WaterEventsCompanion.insert(
                eventId: eventId,
                timingFeedback: timingFeedback,
                offsetDays: offsetDays,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$WaterEventsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({eventId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (eventId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.eventId,
                            referencedTable: $$WaterEventsTableReferences
                                ._eventIdTable(db),
                            referencedColumn:
                                $$WaterEventsTableReferences
                                    ._eventIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WaterEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$PlantAppDb,
      $WaterEventsTable,
      WaterEvent,
      $$WaterEventsTableFilterComposer,
      $$WaterEventsTableOrderingComposer,
      $$WaterEventsTableAnnotationComposer,
      $$WaterEventsTableCreateCompanionBuilder,
      $$WaterEventsTableUpdateCompanionBuilder,
      (WaterEvent, $$WaterEventsTableReferences),
      WaterEvent,
      PrefetchHooks Function({bool eventId})
    >;
typedef $$PhotosTableCreateCompanionBuilder =
    PhotosCompanion Function({
      Value<int> id,
      required int plantId,
      required String date,
      required String filePath,
    });
typedef $$PhotosTableUpdateCompanionBuilder =
    PhotosCompanion Function({
      Value<int> id,
      Value<int> plantId,
      Value<String> date,
      Value<String> filePath,
    });

final class $$PhotosTableReferences
    extends BaseReferences<_$PlantAppDb, $PhotosTable, Photo> {
  $$PhotosTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlantsTable _plantIdTable(_$PlantAppDb db) => db.plants.createAlias(
    $_aliasNameGenerator(db.photos.plantId, db.plants.id),
  );

  $$PlantsTableProcessedTableManager get plantId {
    final $_column = $_itemColumn<int>('plant_id')!;

    final manager = $$PlantsTableTableManager(
      $_db,
      $_db.plants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_plantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PhotosTableFilterComposer extends Composer<_$PlantAppDb, $PhotosTable> {
  $$PhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  $$PlantsTableFilterComposer get plantId {
    final $$PlantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plantId,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableFilterComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableOrderingComposer
    extends Composer<_$PlantAppDb, $PhotosTable> {
  $$PhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlantsTableOrderingComposer get plantId {
    final $$PlantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plantId,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableOrderingComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableAnnotationComposer
    extends Composer<_$PlantAppDb, $PhotosTable> {
  $$PhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  $$PlantsTableAnnotationComposer get plantId {
    final $$PlantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.plantId,
      referencedTable: $db.plants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlantsTableAnnotationComposer(
            $db: $db,
            $table: $db.plants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PhotosTableTableManager
    extends
        RootTableManager<
          _$PlantAppDb,
          $PhotosTable,
          Photo,
          $$PhotosTableFilterComposer,
          $$PhotosTableOrderingComposer,
          $$PhotosTableAnnotationComposer,
          $$PhotosTableCreateCompanionBuilder,
          $$PhotosTableUpdateCompanionBuilder,
          (Photo, $$PhotosTableReferences),
          Photo,
          PrefetchHooks Function({bool plantId})
        > {
  $$PhotosTableTableManager(_$PlantAppDb db, $PhotosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$PhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$PhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$PhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> plantId = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> filePath = const Value.absent(),
              }) => PhotosCompanion(
                id: id,
                plantId: plantId,
                date: date,
                filePath: filePath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int plantId,
                required String date,
                required String filePath,
              }) => PhotosCompanion.insert(
                id: id,
                plantId: plantId,
                date: date,
                filePath: filePath,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$PhotosTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({plantId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (plantId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.plantId,
                            referencedTable: $$PhotosTableReferences
                                ._plantIdTable(db),
                            referencedColumn:
                                $$PhotosTableReferences._plantIdTable(db).id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$PlantAppDb,
      $PhotosTable,
      Photo,
      $$PhotosTableFilterComposer,
      $$PhotosTableOrderingComposer,
      $$PhotosTableAnnotationComposer,
      $$PhotosTableCreateCompanionBuilder,
      $$PhotosTableUpdateCompanionBuilder,
      (Photo, $$PhotosTableReferences),
      Photo,
      PrefetchHooks Function({bool plantId})
    >;

class $PlantAppDbManager {
  final _$PlantAppDb _db;
  $PlantAppDbManager(this._db);
  $$PlantsTableTableManager get plants =>
      $$PlantsTableTableManager(_db, _db.plants);
  $$AccessoriesTableTableManager get accessories =>
      $$AccessoriesTableTableManager(_db, _db.accessories);
  $$EventsTableTableManager get events =>
      $$EventsTableTableManager(_db, _db.events);
  $$EventAccessoriesTableTableManager get eventAccessories =>
      $$EventAccessoriesTableTableManager(_db, _db.eventAccessories);
  $$RepotEventsTableTableManager get repotEvents =>
      $$RepotEventsTableTableManager(_db, _db.repotEvents);
  $$WaterEventsTableTableManager get waterEvents =>
      $$WaterEventsTableTableManager(_db, _db.waterEvents);
  $$PhotosTableTableManager get photos =>
      $$PhotosTableTableManager(_db, _db.photos);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CyclesTable extends Cycles with TableInfo<$CyclesTable, CycleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CyclesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _periodLengthMeta = const VerificationMeta(
    'periodLength',
  );
  @override
  late final GeneratedColumn<int> periodLength = GeneratedColumn<int>(
    'period_length',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cycleLengthMeta = const VerificationMeta(
    'cycleLength',
  );
  @override
  late final GeneratedColumn<int> cycleLength = GeneratedColumn<int>(
    'cycle_length',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isEstimateMeta = const VerificationMeta(
    'isEstimate',
  );
  @override
  late final GeneratedColumn<bool> isEstimate = GeneratedColumn<bool>(
    'is_estimate',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_estimate" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    startDate,
    endDate,
    periodLength,
    cycleLength,
    isEstimate,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cycles';
  @override
  VerificationContext validateIntegrity(
    Insertable<CycleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('period_length')) {
      context.handle(
        _periodLengthMeta,
        periodLength.isAcceptableOrUnknown(
          data['period_length']!,
          _periodLengthMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_periodLengthMeta);
    }
    if (data.containsKey('cycle_length')) {
      context.handle(
        _cycleLengthMeta,
        cycleLength.isAcceptableOrUnknown(
          data['cycle_length']!,
          _cycleLengthMeta,
        ),
      );
    }
    if (data.containsKey('is_estimate')) {
      context.handle(
        _isEstimateMeta,
        isEstimate.isAcceptableOrUnknown(data['is_estimate']!, _isEstimateMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CycleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CycleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      periodLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period_length'],
      )!,
      cycleLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cycle_length'],
      ),
      isEstimate: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_estimate'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $CyclesTable createAlias(String alias) {
    return $CyclesTable(attachedDatabase, alias);
  }
}

class CycleRow extends DataClass implements Insertable<CycleRow> {
  final String id;
  final DateTime startDate;
  final DateTime? endDate;
  final int periodLength;
  final int? cycleLength;
  final bool isEstimate;
  final DateTime updatedAt;
  final bool deleted;
  const CycleRow({
    required this.id,
    required this.startDate,
    this.endDate,
    required this.periodLength,
    this.cycleLength,
    required this.isEstimate,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['period_length'] = Variable<int>(periodLength);
    if (!nullToAbsent || cycleLength != null) {
      map['cycle_length'] = Variable<int>(cycleLength);
    }
    map['is_estimate'] = Variable<bool>(isEstimate);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  CyclesCompanion toCompanion(bool nullToAbsent) {
    return CyclesCompanion(
      id: Value(id),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      periodLength: Value(periodLength),
      cycleLength: cycleLength == null && nullToAbsent
          ? const Value.absent()
          : Value(cycleLength),
      isEstimate: Value(isEstimate),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory CycleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CycleRow(
      id: serializer.fromJson<String>(json['id']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      periodLength: serializer.fromJson<int>(json['periodLength']),
      cycleLength: serializer.fromJson<int?>(json['cycleLength']),
      isEstimate: serializer.fromJson<bool>(json['isEstimate']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'periodLength': serializer.toJson<int>(periodLength),
      'cycleLength': serializer.toJson<int?>(cycleLength),
      'isEstimate': serializer.toJson<bool>(isEstimate),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  CycleRow copyWith({
    String? id,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    int? periodLength,
    Value<int?> cycleLength = const Value.absent(),
    bool? isEstimate,
    DateTime? updatedAt,
    bool? deleted,
  }) => CycleRow(
    id: id ?? this.id,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    periodLength: periodLength ?? this.periodLength,
    cycleLength: cycleLength.present ? cycleLength.value : this.cycleLength,
    isEstimate: isEstimate ?? this.isEstimate,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  CycleRow copyWithCompanion(CyclesCompanion data) {
    return CycleRow(
      id: data.id.present ? data.id.value : this.id,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      periodLength: data.periodLength.present
          ? data.periodLength.value
          : this.periodLength,
      cycleLength: data.cycleLength.present
          ? data.cycleLength.value
          : this.cycleLength,
      isEstimate: data.isEstimate.present
          ? data.isEstimate.value
          : this.isEstimate,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CycleRow(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('periodLength: $periodLength, ')
          ..write('cycleLength: $cycleLength, ')
          ..write('isEstimate: $isEstimate, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    startDate,
    endDate,
    periodLength,
    cycleLength,
    isEstimate,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CycleRow &&
          other.id == this.id &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.periodLength == this.periodLength &&
          other.cycleLength == this.cycleLength &&
          other.isEstimate == this.isEstimate &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class CyclesCompanion extends UpdateCompanion<CycleRow> {
  final Value<String> id;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<int> periodLength;
  final Value<int?> cycleLength;
  final Value<bool> isEstimate;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const CyclesCompanion({
    this.id = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.periodLength = const Value.absent(),
    this.cycleLength = const Value.absent(),
    this.isEstimate = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CyclesCompanion.insert({
    required String id,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    required int periodLength,
    this.cycleLength = const Value.absent(),
    this.isEstimate = const Value.absent(),
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       startDate = Value(startDate),
       periodLength = Value(periodLength),
       updatedAt = Value(updatedAt);
  static Insertable<CycleRow> custom({
    Expression<String>? id,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? periodLength,
    Expression<int>? cycleLength,
    Expression<bool>? isEstimate,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (periodLength != null) 'period_length': periodLength,
      if (cycleLength != null) 'cycle_length': cycleLength,
      if (isEstimate != null) 'is_estimate': isEstimate,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CyclesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<int>? periodLength,
    Value<int?>? cycleLength,
    Value<bool>? isEstimate,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return CyclesCompanion(
      id: id ?? this.id,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      periodLength: periodLength ?? this.periodLength,
      cycleLength: cycleLength ?? this.cycleLength,
      isEstimate: isEstimate ?? this.isEstimate,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (periodLength.present) {
      map['period_length'] = Variable<int>(periodLength.value);
    }
    if (cycleLength.present) {
      map['cycle_length'] = Variable<int>(cycleLength.value);
    }
    if (isEstimate.present) {
      map['is_estimate'] = Variable<bool>(isEstimate.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CyclesCompanion(')
          ..write('id: $id, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('periodLength: $periodLength, ')
          ..write('cycleLength: $cycleLength, ')
          ..write('isEstimate: $isEstimate, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyLogsTable extends DailyLogs
    with TableInfo<$DailyLogsTable, DailyLogRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
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
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _flowMeta = const VerificationMeta('flow');
  @override
  late final GeneratedColumn<String> flow = GeneratedColumn<String>(
    'flow',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _symptomsMeta = const VerificationMeta(
    'symptoms',
  );
  @override
  late final GeneratedColumn<String> symptoms = GeneratedColumn<String>(
    'symptoms',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _moodMeta = const VerificationMeta('mood');
  @override
  late final GeneratedColumn<String> mood = GeneratedColumn<String>(
    'mood',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    loggedAt,
    flow,
    symptoms,
    mood,
    note,
    updatedAt,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyLogRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    if (data.containsKey('flow')) {
      context.handle(
        _flowMeta,
        flow.isAcceptableOrUnknown(data['flow']!, _flowMeta),
      );
    }
    if (data.containsKey('symptoms')) {
      context.handle(
        _symptomsMeta,
        symptoms.isAcceptableOrUnknown(data['symptoms']!, _symptomsMeta),
      );
    }
    if (data.containsKey('mood')) {
      context.handle(
        _moodMeta,
        mood.isAcceptableOrUnknown(data['mood']!, _moodMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DailyLogRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyLogRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_at'],
      )!,
      flow: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flow'],
      )!,
      symptoms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symptoms'],
      )!,
      mood: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $DailyLogsTable createAlias(String alias) {
    return $DailyLogsTable(attachedDatabase, alias);
  }
}

class DailyLogRow extends DataClass implements Insertable<DailyLogRow> {
  final String id;
  final String date;
  final DateTime loggedAt;
  final String flow;
  final String symptoms;
  final String mood;
  final String? note;
  final DateTime updatedAt;
  final bool deleted;
  const DailyLogRow({
    required this.id,
    required this.date,
    required this.loggedAt,
    required this.flow,
    required this.symptoms,
    required this.mood,
    this.note,
    required this.updatedAt,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<String>(date);
    map['logged_at'] = Variable<DateTime>(loggedAt);
    map['flow'] = Variable<String>(flow);
    map['symptoms'] = Variable<String>(symptoms);
    map['mood'] = Variable<String>(mood);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  DailyLogsCompanion toCompanion(bool nullToAbsent) {
    return DailyLogsCompanion(
      id: Value(id),
      date: Value(date),
      loggedAt: Value(loggedAt),
      flow: Value(flow),
      symptoms: Value(symptoms),
      mood: Value(mood),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      updatedAt: Value(updatedAt),
      deleted: Value(deleted),
    );
  }

  factory DailyLogRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyLogRow(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<String>(json['date']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
      flow: serializer.fromJson<String>(json['flow']),
      symptoms: serializer.fromJson<String>(json['symptoms']),
      mood: serializer.fromJson<String>(json['mood']),
      note: serializer.fromJson<String?>(json['note']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<String>(date),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
      'flow': serializer.toJson<String>(flow),
      'symptoms': serializer.toJson<String>(symptoms),
      'mood': serializer.toJson<String>(mood),
      'note': serializer.toJson<String?>(note),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  DailyLogRow copyWith({
    String? id,
    String? date,
    DateTime? loggedAt,
    String? flow,
    String? symptoms,
    String? mood,
    Value<String?> note = const Value.absent(),
    DateTime? updatedAt,
    bool? deleted,
  }) => DailyLogRow(
    id: id ?? this.id,
    date: date ?? this.date,
    loggedAt: loggedAt ?? this.loggedAt,
    flow: flow ?? this.flow,
    symptoms: symptoms ?? this.symptoms,
    mood: mood ?? this.mood,
    note: note.present ? note.value : this.note,
    updatedAt: updatedAt ?? this.updatedAt,
    deleted: deleted ?? this.deleted,
  );
  DailyLogRow copyWithCompanion(DailyLogsCompanion data) {
    return DailyLogRow(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
      flow: data.flow.present ? data.flow.value : this.flow,
      symptoms: data.symptoms.present ? data.symptoms.value : this.symptoms,
      mood: data.mood.present ? data.mood.value : this.mood,
      note: data.note.present ? data.note.value : this.note,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyLogRow(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('flow: $flow, ')
          ..write('symptoms: $symptoms, ')
          ..write('mood: $mood, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    loggedAt,
    flow,
    symptoms,
    mood,
    note,
    updatedAt,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyLogRow &&
          other.id == this.id &&
          other.date == this.date &&
          other.loggedAt == this.loggedAt &&
          other.flow == this.flow &&
          other.symptoms == this.symptoms &&
          other.mood == this.mood &&
          other.note == this.note &&
          other.updatedAt == this.updatedAt &&
          other.deleted == this.deleted);
}

class DailyLogsCompanion extends UpdateCompanion<DailyLogRow> {
  final Value<String> id;
  final Value<String> date;
  final Value<DateTime> loggedAt;
  final Value<String> flow;
  final Value<String> symptoms;
  final Value<String> mood;
  final Value<String?> note;
  final Value<DateTime> updatedAt;
  final Value<bool> deleted;
  final Value<int> rowid;
  const DailyLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.flow = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.mood = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyLogsCompanion.insert({
    required String id,
    required String date,
    required DateTime loggedAt,
    this.flow = const Value.absent(),
    this.symptoms = const Value.absent(),
    this.mood = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime updatedAt,
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       loggedAt = Value(loggedAt),
       updatedAt = Value(updatedAt);
  static Insertable<DailyLogRow> custom({
    Expression<String>? id,
    Expression<String>? date,
    Expression<DateTime>? loggedAt,
    Expression<String>? flow,
    Expression<String>? symptoms,
    Expression<String>? mood,
    Expression<String>? note,
    Expression<DateTime>? updatedAt,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (flow != null) 'flow': flow,
      if (symptoms != null) 'symptoms': symptoms,
      if (mood != null) 'mood': mood,
      if (note != null) 'note': note,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? date,
    Value<DateTime>? loggedAt,
    Value<String>? flow,
    Value<String>? symptoms,
    Value<String>? mood,
    Value<String?>? note,
    Value<DateTime>? updatedAt,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return DailyLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      loggedAt: loggedAt ?? this.loggedAt,
      flow: flow ?? this.flow,
      symptoms: symptoms ?? this.symptoms,
      mood: mood ?? this.mood,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (flow.present) {
      map['flow'] = Variable<String>(flow.value);
    }
    if (symptoms.present) {
      map['symptoms'] = Variable<String>(symptoms.value);
    }
    if (mood.present) {
      map['mood'] = Variable<String>(mood.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('flow: $flow, ')
          ..write('symptoms: $symptoms, ')
          ..write('mood: $mood, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, SettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class SettingRow extends DataClass implements Insertable<SettingRow> {
  final String key;
  final String value;
  const SettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory SettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingRow copyWith({String? key, String? value}) =>
      SettingRow(key: key ?? this.key, value: value ?? this.value);
  SettingRow copyWithCompanion(SettingsCompanion data) {
    return SettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<SettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ArticlesTable extends Articles
    with TableInfo<$ArticlesTable, ArticleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArticlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _langMeta = const VerificationMeta('lang');
  @override
  late final GeneratedColumn<String> lang = GeneratedColumn<String>(
    'lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reviewedByMeta = const VerificationMeta(
    'reviewedBy',
  );
  @override
  late final GeneratedColumn<String> reviewedBy = GeneratedColumn<String>(
    'reviewed_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reviewedOnMeta = const VerificationMeta(
    'reviewedOn',
  );
  @override
  late final GeneratedColumn<DateTime> reviewedOn = GeneratedColumn<DateTime>(
    'reviewed_on',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _proposedReviewerMeta = const VerificationMeta(
    'proposedReviewer',
  );
  @override
  late final GeneratedColumn<String> proposedReviewer = GeneratedColumn<String>(
    'proposed_reviewer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _savedMeta = const VerificationMeta('saved');
  @override
  late final GeneratedColumn<bool> saved = GeneratedColumn<bool>(
    'saved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("saved" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lang,
    category,
    title,
    body,
    reviewedBy,
    reviewedOn,
    createdAt,
    author,
    proposedReviewer,
    updatedAt,
    saved,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'articles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ArticleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('lang')) {
      context.handle(
        _langMeta,
        lang.isAcceptableOrUnknown(data['lang']!, _langMeta),
      );
    } else if (isInserting) {
      context.missing(_langMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('reviewed_by')) {
      context.handle(
        _reviewedByMeta,
        reviewedBy.isAcceptableOrUnknown(data['reviewed_by']!, _reviewedByMeta),
      );
    }
    if (data.containsKey('reviewed_on')) {
      context.handle(
        _reviewedOnMeta,
        reviewedOn.isAcceptableOrUnknown(data['reviewed_on']!, _reviewedOnMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('proposed_reviewer')) {
      context.handle(
        _proposedReviewerMeta,
        proposedReviewer.isAcceptableOrUnknown(
          data['proposed_reviewer']!,
          _proposedReviewerMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('saved')) {
      context.handle(
        _savedMeta,
        saved.isAcceptableOrUnknown(data['saved']!, _savedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, lang};
  @override
  ArticleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ArticleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lang'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      reviewedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reviewed_by'],
      ),
      reviewedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reviewed_on'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      proposedReviewer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}proposed_reviewer'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      saved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}saved'],
      )!,
    );
  }

  @override
  $ArticlesTable createAlias(String alias) {
    return $ArticlesTable(attachedDatabase, alias);
  }
}

class ArticleRow extends DataClass implements Insertable<ArticleRow> {
  final String id;
  final String lang;
  final String category;
  final String title;
  final String body;
  final String? reviewedBy;
  final DateTime? reviewedOn;

  /// When the article was first created. Kept when it is edited again.
  final DateTime? createdAt;

  /// When the article was published. Set by publishing, cleared by a draft save.
  /// (Stored in the reviewed_on field.)
  /// Who wrote the article (shown as "Written by").
  final String? author;

  /// Reviewer named while this language is still a draft. It becomes
  /// [reviewedBy] only when the whole article is published.
  final String? proposedReviewer;
  final DateTime updatedAt;
  final bool saved;
  const ArticleRow({
    required this.id,
    required this.lang,
    required this.category,
    required this.title,
    required this.body,
    this.reviewedBy,
    this.reviewedOn,
    this.createdAt,
    this.author,
    this.proposedReviewer,
    required this.updatedAt,
    required this.saved,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lang'] = Variable<String>(lang);
    map['category'] = Variable<String>(category);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || reviewedBy != null) {
      map['reviewed_by'] = Variable<String>(reviewedBy);
    }
    if (!nullToAbsent || reviewedOn != null) {
      map['reviewed_on'] = Variable<DateTime>(reviewedOn);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || proposedReviewer != null) {
      map['proposed_reviewer'] = Variable<String>(proposedReviewer);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['saved'] = Variable<bool>(saved);
    return map;
  }

  ArticlesCompanion toCompanion(bool nullToAbsent) {
    return ArticlesCompanion(
      id: Value(id),
      lang: Value(lang),
      category: Value(category),
      title: Value(title),
      body: Value(body),
      reviewedBy: reviewedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewedBy),
      reviewedOn: reviewedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewedOn),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      proposedReviewer: proposedReviewer == null && nullToAbsent
          ? const Value.absent()
          : Value(proposedReviewer),
      updatedAt: Value(updatedAt),
      saved: Value(saved),
    );
  }

  factory ArticleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ArticleRow(
      id: serializer.fromJson<String>(json['id']),
      lang: serializer.fromJson<String>(json['lang']),
      category: serializer.fromJson<String>(json['category']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      reviewedBy: serializer.fromJson<String?>(json['reviewedBy']),
      reviewedOn: serializer.fromJson<DateTime?>(json['reviewedOn']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      author: serializer.fromJson<String?>(json['author']),
      proposedReviewer: serializer.fromJson<String?>(json['proposedReviewer']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      saved: serializer.fromJson<bool>(json['saved']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lang': serializer.toJson<String>(lang),
      'category': serializer.toJson<String>(category),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'reviewedBy': serializer.toJson<String?>(reviewedBy),
      'reviewedOn': serializer.toJson<DateTime?>(reviewedOn),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'author': serializer.toJson<String?>(author),
      'proposedReviewer': serializer.toJson<String?>(proposedReviewer),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'saved': serializer.toJson<bool>(saved),
    };
  }

  ArticleRow copyWith({
    String? id,
    String? lang,
    String? category,
    String? title,
    String? body,
    Value<String?> reviewedBy = const Value.absent(),
    Value<DateTime?> reviewedOn = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
    Value<String?> author = const Value.absent(),
    Value<String?> proposedReviewer = const Value.absent(),
    DateTime? updatedAt,
    bool? saved,
  }) => ArticleRow(
    id: id ?? this.id,
    lang: lang ?? this.lang,
    category: category ?? this.category,
    title: title ?? this.title,
    body: body ?? this.body,
    reviewedBy: reviewedBy.present ? reviewedBy.value : this.reviewedBy,
    reviewedOn: reviewedOn.present ? reviewedOn.value : this.reviewedOn,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    author: author.present ? author.value : this.author,
    proposedReviewer: proposedReviewer.present
        ? proposedReviewer.value
        : this.proposedReviewer,
    updatedAt: updatedAt ?? this.updatedAt,
    saved: saved ?? this.saved,
  );
  ArticleRow copyWithCompanion(ArticlesCompanion data) {
    return ArticleRow(
      id: data.id.present ? data.id.value : this.id,
      lang: data.lang.present ? data.lang.value : this.lang,
      category: data.category.present ? data.category.value : this.category,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      reviewedBy: data.reviewedBy.present
          ? data.reviewedBy.value
          : this.reviewedBy,
      reviewedOn: data.reviewedOn.present
          ? data.reviewedOn.value
          : this.reviewedOn,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      author: data.author.present ? data.author.value : this.author,
      proposedReviewer: data.proposedReviewer.present
          ? data.proposedReviewer.value
          : this.proposedReviewer,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      saved: data.saved.present ? data.saved.value : this.saved,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ArticleRow(')
          ..write('id: $id, ')
          ..write('lang: $lang, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('reviewedBy: $reviewedBy, ')
          ..write('reviewedOn: $reviewedOn, ')
          ..write('createdAt: $createdAt, ')
          ..write('author: $author, ')
          ..write('proposedReviewer: $proposedReviewer, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('saved: $saved')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    lang,
    category,
    title,
    body,
    reviewedBy,
    reviewedOn,
    createdAt,
    author,
    proposedReviewer,
    updatedAt,
    saved,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ArticleRow &&
          other.id == this.id &&
          other.lang == this.lang &&
          other.category == this.category &&
          other.title == this.title &&
          other.body == this.body &&
          other.reviewedBy == this.reviewedBy &&
          other.reviewedOn == this.reviewedOn &&
          other.createdAt == this.createdAt &&
          other.author == this.author &&
          other.proposedReviewer == this.proposedReviewer &&
          other.updatedAt == this.updatedAt &&
          other.saved == this.saved);
}

class ArticlesCompanion extends UpdateCompanion<ArticleRow> {
  final Value<String> id;
  final Value<String> lang;
  final Value<String> category;
  final Value<String> title;
  final Value<String> body;
  final Value<String?> reviewedBy;
  final Value<DateTime?> reviewedOn;
  final Value<DateTime?> createdAt;
  final Value<String?> author;
  final Value<String?> proposedReviewer;
  final Value<DateTime> updatedAt;
  final Value<bool> saved;
  final Value<int> rowid;
  const ArticlesCompanion({
    this.id = const Value.absent(),
    this.lang = const Value.absent(),
    this.category = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.reviewedBy = const Value.absent(),
    this.reviewedOn = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.author = const Value.absent(),
    this.proposedReviewer = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.saved = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ArticlesCompanion.insert({
    required String id,
    required String lang,
    required String category,
    required String title,
    required String body,
    this.reviewedBy = const Value.absent(),
    this.reviewedOn = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.author = const Value.absent(),
    this.proposedReviewer = const Value.absent(),
    required DateTime updatedAt,
    this.saved = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       lang = Value(lang),
       category = Value(category),
       title = Value(title),
       body = Value(body),
       updatedAt = Value(updatedAt);
  static Insertable<ArticleRow> custom({
    Expression<String>? id,
    Expression<String>? lang,
    Expression<String>? category,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? reviewedBy,
    Expression<DateTime>? reviewedOn,
    Expression<DateTime>? createdAt,
    Expression<String>? author,
    Expression<String>? proposedReviewer,
    Expression<DateTime>? updatedAt,
    Expression<bool>? saved,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lang != null) 'lang': lang,
      if (category != null) 'category': category,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (reviewedBy != null) 'reviewed_by': reviewedBy,
      if (reviewedOn != null) 'reviewed_on': reviewedOn,
      if (createdAt != null) 'created_at': createdAt,
      if (author != null) 'author': author,
      if (proposedReviewer != null) 'proposed_reviewer': proposedReviewer,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (saved != null) 'saved': saved,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ArticlesCompanion copyWith({
    Value<String>? id,
    Value<String>? lang,
    Value<String>? category,
    Value<String>? title,
    Value<String>? body,
    Value<String?>? reviewedBy,
    Value<DateTime?>? reviewedOn,
    Value<DateTime?>? createdAt,
    Value<String?>? author,
    Value<String?>? proposedReviewer,
    Value<DateTime>? updatedAt,
    Value<bool>? saved,
    Value<int>? rowid,
  }) {
    return ArticlesCompanion(
      id: id ?? this.id,
      lang: lang ?? this.lang,
      category: category ?? this.category,
      title: title ?? this.title,
      body: body ?? this.body,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedOn: reviewedOn ?? this.reviewedOn,
      createdAt: createdAt ?? this.createdAt,
      author: author ?? this.author,
      proposedReviewer: proposedReviewer ?? this.proposedReviewer,
      updatedAt: updatedAt ?? this.updatedAt,
      saved: saved ?? this.saved,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lang.present) {
      map['lang'] = Variable<String>(lang.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (reviewedBy.present) {
      map['reviewed_by'] = Variable<String>(reviewedBy.value);
    }
    if (reviewedOn.present) {
      map['reviewed_on'] = Variable<DateTime>(reviewedOn.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (proposedReviewer.present) {
      map['proposed_reviewer'] = Variable<String>(proposedReviewer.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (saved.present) {
      map['saved'] = Variable<bool>(saved.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArticlesCompanion(')
          ..write('id: $id, ')
          ..write('lang: $lang, ')
          ..write('category: $category, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('reviewedBy: $reviewedBy, ')
          ..write('reviewedOn: $reviewedOn, ')
          ..write('createdAt: $createdAt, ')
          ..write('author: $author, ')
          ..write('proposedReviewer: $proposedReviewer, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('saved: $saved, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HealthCentresTable extends HealthCentres
    with TableInfo<$HealthCentresTable, HealthCentreRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthCentresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _districtMeta = const VerificationMeta(
    'district',
  );
  @override
  late final GeneratedColumn<String> district = GeneratedColumn<String>(
    'district',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectorMeta = const VerificationMeta('sector');
  @override
  late final GeneratedColumn<String> sector = GeneratedColumn<String>(
    'sector',
    aliasedName,
    false,
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
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _servicesMeta = const VerificationMeta(
    'services',
  );
  @override
  late final GeneratedColumn<String> services = GeneratedColumn<String>(
    'services',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    district,
    sector,
    name,
    phone,
    services,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_centres';
  @override
  VerificationContext validateIntegrity(
    Insertable<HealthCentreRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('district')) {
      context.handle(
        _districtMeta,
        district.isAcceptableOrUnknown(data['district']!, _districtMeta),
      );
    } else if (isInserting) {
      context.missing(_districtMeta);
    }
    if (data.containsKey('sector')) {
      context.handle(
        _sectorMeta,
        sector.isAcceptableOrUnknown(data['sector']!, _sectorMeta),
      );
    } else if (isInserting) {
      context.missing(_sectorMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('services')) {
      context.handle(
        _servicesMeta,
        services.isAcceptableOrUnknown(data['services']!, _servicesMeta),
      );
    } else if (isInserting) {
      context.missing(_servicesMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HealthCentreRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthCentreRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      district: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}district'],
      )!,
      sector: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sector'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      services: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}services'],
      )!,
    );
  }

  @override
  $HealthCentresTable createAlias(String alias) {
    return $HealthCentresTable(attachedDatabase, alias);
  }
}

class HealthCentreRow extends DataClass implements Insertable<HealthCentreRow> {
  final String id;
  final String district;
  final String sector;
  final String name;
  final String phone;
  final String services;
  const HealthCentreRow({
    required this.id,
    required this.district,
    required this.sector,
    required this.name,
    required this.phone,
    required this.services,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['district'] = Variable<String>(district);
    map['sector'] = Variable<String>(sector);
    map['name'] = Variable<String>(name);
    map['phone'] = Variable<String>(phone);
    map['services'] = Variable<String>(services);
    return map;
  }

  HealthCentresCompanion toCompanion(bool nullToAbsent) {
    return HealthCentresCompanion(
      id: Value(id),
      district: Value(district),
      sector: Value(sector),
      name: Value(name),
      phone: Value(phone),
      services: Value(services),
    );
  }

  factory HealthCentreRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthCentreRow(
      id: serializer.fromJson<String>(json['id']),
      district: serializer.fromJson<String>(json['district']),
      sector: serializer.fromJson<String>(json['sector']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String>(json['phone']),
      services: serializer.fromJson<String>(json['services']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'district': serializer.toJson<String>(district),
      'sector': serializer.toJson<String>(sector),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String>(phone),
      'services': serializer.toJson<String>(services),
    };
  }

  HealthCentreRow copyWith({
    String? id,
    String? district,
    String? sector,
    String? name,
    String? phone,
    String? services,
  }) => HealthCentreRow(
    id: id ?? this.id,
    district: district ?? this.district,
    sector: sector ?? this.sector,
    name: name ?? this.name,
    phone: phone ?? this.phone,
    services: services ?? this.services,
  );
  HealthCentreRow copyWithCompanion(HealthCentresCompanion data) {
    return HealthCentreRow(
      id: data.id.present ? data.id.value : this.id,
      district: data.district.present ? data.district.value : this.district,
      sector: data.sector.present ? data.sector.value : this.sector,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      services: data.services.present ? data.services.value : this.services,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthCentreRow(')
          ..write('id: $id, ')
          ..write('district: $district, ')
          ..write('sector: $sector, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('services: $services')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, district, sector, name, phone, services);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthCentreRow &&
          other.id == this.id &&
          other.district == this.district &&
          other.sector == this.sector &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.services == this.services);
}

class HealthCentresCompanion extends UpdateCompanion<HealthCentreRow> {
  final Value<String> id;
  final Value<String> district;
  final Value<String> sector;
  final Value<String> name;
  final Value<String> phone;
  final Value<String> services;
  final Value<int> rowid;
  const HealthCentresCompanion({
    this.id = const Value.absent(),
    this.district = const Value.absent(),
    this.sector = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.services = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HealthCentresCompanion.insert({
    required String id,
    required String district,
    required String sector,
    required String name,
    required String phone,
    required String services,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       district = Value(district),
       sector = Value(sector),
       name = Value(name),
       phone = Value(phone),
       services = Value(services);
  static Insertable<HealthCentreRow> custom({
    Expression<String>? id,
    Expression<String>? district,
    Expression<String>? sector,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<String>? services,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (district != null) 'district': district,
      if (sector != null) 'sector': sector,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (services != null) 'services': services,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HealthCentresCompanion copyWith({
    Value<String>? id,
    Value<String>? district,
    Value<String>? sector,
    Value<String>? name,
    Value<String>? phone,
    Value<String>? services,
    Value<int>? rowid,
  }) {
    return HealthCentresCompanion(
      id: id ?? this.id,
      district: district ?? this.district,
      sector: sector ?? this.sector,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      services: services ?? this.services,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (district.present) {
      map['district'] = Variable<String>(district.value);
    }
    if (sector.present) {
      map['sector'] = Variable<String>(sector.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (services.present) {
      map['services'] = Variable<String>(services.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthCentresCompanion(')
          ..write('id: $id, ')
          ..write('district: $district, ')
          ..write('sector: $sector, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('services: $services, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _targetTableMeta = const VerificationMeta(
    'targetTable',
  );
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
    'table_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetTable,
    recordId,
    action,
    createdAt,
    synced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('table_name')) {
      context.handle(
        _targetTableMeta,
        targetTable.isAcceptableOrUnknown(
          data['table_name']!,
          _targetTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      targetTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueRow extends DataClass implements Insertable<SyncQueueRow> {
  final int id;
  final String targetTable;
  final String recordId;
  final String action;
  final DateTime createdAt;
  final bool synced;
  const SyncQueueRow({
    required this.id,
    required this.targetTable,
    required this.recordId,
    required this.action,
    required this.createdAt,
    required this.synced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['table_name'] = Variable<String>(targetTable);
    map['record_id'] = Variable<String>(recordId);
    map['action'] = Variable<String>(action);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      targetTable: Value(targetTable),
      recordId: Value(recordId),
      action: Value(action),
      createdAt: Value(createdAt),
      synced: Value(synced),
    );
  }

  factory SyncQueueRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueRow(
      id: serializer.fromJson<int>(json['id']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      recordId: serializer.fromJson<String>(json['recordId']),
      action: serializer.fromJson<String>(json['action']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'targetTable': serializer.toJson<String>(targetTable),
      'recordId': serializer.toJson<String>(recordId),
      'action': serializer.toJson<String>(action),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  SyncQueueRow copyWith({
    int? id,
    String? targetTable,
    String? recordId,
    String? action,
    DateTime? createdAt,
    bool? synced,
  }) => SyncQueueRow(
    id: id ?? this.id,
    targetTable: targetTable ?? this.targetTable,
    recordId: recordId ?? this.recordId,
    action: action ?? this.action,
    createdAt: createdAt ?? this.createdAt,
    synced: synced ?? this.synced,
  );
  SyncQueueRow copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueRow(
      id: data.id.present ? data.id.value : this.id,
      targetTable: data.targetTable.present
          ? data.targetTable.value
          : this.targetTable,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      action: data.action.present ? data.action.value : this.action,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueRow(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('recordId: $recordId, ')
          ..write('action: $action, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, targetTable, recordId, action, createdAt, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueRow &&
          other.id == this.id &&
          other.targetTable == this.targetTable &&
          other.recordId == this.recordId &&
          other.action == this.action &&
          other.createdAt == this.createdAt &&
          other.synced == this.synced);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueRow> {
  final Value<int> id;
  final Value<String> targetTable;
  final Value<String> recordId;
  final Value<String> action;
  final Value<DateTime> createdAt;
  final Value<bool> synced;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.recordId = const Value.absent(),
    this.action = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.synced = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String targetTable,
    required String recordId,
    required String action,
    required DateTime createdAt,
    this.synced = const Value.absent(),
  }) : targetTable = Value(targetTable),
       recordId = Value(recordId),
       action = Value(action),
       createdAt = Value(createdAt);
  static Insertable<SyncQueueRow> custom({
    Expression<int>? id,
    Expression<String>? targetTable,
    Expression<String>? recordId,
    Expression<String>? action,
    Expression<DateTime>? createdAt,
    Expression<bool>? synced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetTable != null) 'table_name': targetTable,
      if (recordId != null) 'record_id': recordId,
      if (action != null) 'action': action,
      if (createdAt != null) 'created_at': createdAt,
      if (synced != null) 'synced': synced,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? targetTable,
    Value<String>? recordId,
    Value<String>? action,
    Value<DateTime>? createdAt,
    Value<bool>? synced,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      targetTable: targetTable ?? this.targetTable,
      recordId: recordId ?? this.recordId,
      action: action ?? this.action,
      createdAt: createdAt ?? this.createdAt,
      synced: synced ?? this.synced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (targetTable.present) {
      map['table_name'] = Variable<String>(targetTable.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('recordId: $recordId, ')
          ..write('action: $action, ')
          ..write('createdAt: $createdAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }
}

class $ContentOutboxTable extends ContentOutbox
    with TableInfo<$ContentOutboxTable, ContentOutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ContentOutboxTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, kind, payload, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'content_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<ContentOutboxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ContentOutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ContentOutboxRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ContentOutboxTable createAlias(String alias) {
    return $ContentOutboxTable(attachedDatabase, alias);
  }
}

class ContentOutboxRow extends DataClass
    implements Insertable<ContentOutboxRow> {
  final int id;
  final String kind;
  final String payload;
  final DateTime createdAt;
  const ContentOutboxRow({
    required this.id,
    required this.kind,
    required this.payload,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['kind'] = Variable<String>(kind);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ContentOutboxCompanion toCompanion(bool nullToAbsent) {
    return ContentOutboxCompanion(
      id: Value(id),
      kind: Value(kind),
      payload: Value(payload),
      createdAt: Value(createdAt),
    );
  }

  factory ContentOutboxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ContentOutboxRow(
      id: serializer.fromJson<int>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(kind),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ContentOutboxRow copyWith({
    int? id,
    String? kind,
    String? payload,
    DateTime? createdAt,
  }) => ContentOutboxRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
  );
  ContentOutboxRow copyWithCompanion(ContentOutboxCompanion data) {
    return ContentOutboxRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ContentOutboxRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kind, payload, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ContentOutboxRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt);
}

class ContentOutboxCompanion extends UpdateCompanion<ContentOutboxRow> {
  final Value<int> id;
  final Value<String> kind;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  const ContentOutboxCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ContentOutboxCompanion.insert({
    this.id = const Value.absent(),
    required String kind,
    required String payload,
    required DateTime createdAt,
  }) : kind = Value(kind),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<ContentOutboxRow> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ContentOutboxCompanion copyWith({
    Value<int>? id,
    Value<String>? kind,
    Value<String>? payload,
    Value<DateTime>? createdAt,
  }) {
    return ContentOutboxCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ContentOutboxCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$DonzelaDatabase extends GeneratedDatabase {
  _$DonzelaDatabase(QueryExecutor e) : super(e);
  $DonzelaDatabaseManager get managers => $DonzelaDatabaseManager(this);
  late final $CyclesTable cycles = $CyclesTable(this);
  late final $DailyLogsTable dailyLogs = $DailyLogsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $ArticlesTable articles = $ArticlesTable(this);
  late final $HealthCentresTable healthCentres = $HealthCentresTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $ContentOutboxTable contentOutbox = $ContentOutboxTable(this);
  late final CyclesDao cyclesDao = CyclesDao(this as DonzelaDatabase);
  late final DailyLogsDao dailyLogsDao = DailyLogsDao(this as DonzelaDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as DonzelaDatabase);
  late final ContentDao contentDao = ContentDao(this as DonzelaDatabase);
  late final SyncQueueDao syncQueueDao = SyncQueueDao(this as DonzelaDatabase);
  late final ContentOutboxDao contentOutboxDao = ContentOutboxDao(
    this as DonzelaDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cycles,
    dailyLogs,
    settings,
    articles,
    healthCentres,
    syncQueue,
    contentOutbox,
  ];
}

typedef $$CyclesTableCreateCompanionBuilder =
    CyclesCompanion Function({
      required String id,
      required DateTime startDate,
      Value<DateTime?> endDate,
      required int periodLength,
      Value<int?> cycleLength,
      Value<bool> isEstimate,
      required DateTime updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$CyclesTableUpdateCompanionBuilder =
    CyclesCompanion Function({
      Value<String> id,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<int> periodLength,
      Value<int?> cycleLength,
      Value<bool> isEstimate,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$CyclesTableFilterComposer
    extends Composer<_$DonzelaDatabase, $CyclesTable> {
  $$CyclesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get periodLength => $composableBuilder(
    column: $table.periodLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cycleLength => $composableBuilder(
    column: $table.cycleLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEstimate => $composableBuilder(
    column: $table.isEstimate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CyclesTableOrderingComposer
    extends Composer<_$DonzelaDatabase, $CyclesTable> {
  $$CyclesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get periodLength => $composableBuilder(
    column: $table.periodLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cycleLength => $composableBuilder(
    column: $table.cycleLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEstimate => $composableBuilder(
    column: $table.isEstimate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CyclesTableAnnotationComposer
    extends Composer<_$DonzelaDatabase, $CyclesTable> {
  $$CyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get periodLength => $composableBuilder(
    column: $table.periodLength,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cycleLength => $composableBuilder(
    column: $table.cycleLength,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEstimate => $composableBuilder(
    column: $table.isEstimate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$CyclesTableTableManager
    extends
        RootTableManager<
          _$DonzelaDatabase,
          $CyclesTable,
          CycleRow,
          $$CyclesTableFilterComposer,
          $$CyclesTableOrderingComposer,
          $$CyclesTableAnnotationComposer,
          $$CyclesTableCreateCompanionBuilder,
          $$CyclesTableUpdateCompanionBuilder,
          (CycleRow, BaseReferences<_$DonzelaDatabase, $CyclesTable, CycleRow>),
          CycleRow,
          PrefetchHooks Function()
        > {
  $$CyclesTableTableManager(_$DonzelaDatabase db, $CyclesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CyclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<int> periodLength = const Value.absent(),
                Value<int?> cycleLength = const Value.absent(),
                Value<bool> isEstimate = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CyclesCompanion(
                id: id,
                startDate: startDate,
                endDate: endDate,
                periodLength: periodLength,
                cycleLength: cycleLength,
                isEstimate: isEstimate,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                required int periodLength,
                Value<int?> cycleLength = const Value.absent(),
                Value<bool> isEstimate = const Value.absent(),
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CyclesCompanion.insert(
                id: id,
                startDate: startDate,
                endDate: endDate,
                periodLength: periodLength,
                cycleLength: cycleLength,
                isEstimate: isEstimate,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CyclesTableProcessedTableManager =
    ProcessedTableManager<
      _$DonzelaDatabase,
      $CyclesTable,
      CycleRow,
      $$CyclesTableFilterComposer,
      $$CyclesTableOrderingComposer,
      $$CyclesTableAnnotationComposer,
      $$CyclesTableCreateCompanionBuilder,
      $$CyclesTableUpdateCompanionBuilder,
      (CycleRow, BaseReferences<_$DonzelaDatabase, $CyclesTable, CycleRow>),
      CycleRow,
      PrefetchHooks Function()
    >;
typedef $$DailyLogsTableCreateCompanionBuilder =
    DailyLogsCompanion Function({
      required String id,
      required String date,
      required DateTime loggedAt,
      Value<String> flow,
      Value<String> symptoms,
      Value<String> mood,
      Value<String?> note,
      required DateTime updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });
typedef $$DailyLogsTableUpdateCompanionBuilder =
    DailyLogsCompanion Function({
      Value<String> id,
      Value<String> date,
      Value<DateTime> loggedAt,
      Value<String> flow,
      Value<String> symptoms,
      Value<String> mood,
      Value<String?> note,
      Value<DateTime> updatedAt,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$DailyLogsTableFilterComposer
    extends Composer<_$DonzelaDatabase, $DailyLogsTable> {
  $$DailyLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flow => $composableBuilder(
    column: $table.flow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyLogsTableOrderingComposer
    extends Composer<_$DonzelaDatabase, $DailyLogsTable> {
  $$DailyLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flow => $composableBuilder(
    column: $table.flow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symptoms => $composableBuilder(
    column: $table.symptoms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mood => $composableBuilder(
    column: $table.mood,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyLogsTableAnnotationComposer
    extends Composer<_$DonzelaDatabase, $DailyLogsTable> {
  $$DailyLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  GeneratedColumn<String> get flow =>
      $composableBuilder(column: $table.flow, builder: (column) => column);

  GeneratedColumn<String> get symptoms =>
      $composableBuilder(column: $table.symptoms, builder: (column) => column);

  GeneratedColumn<String> get mood =>
      $composableBuilder(column: $table.mood, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$DailyLogsTableTableManager
    extends
        RootTableManager<
          _$DonzelaDatabase,
          $DailyLogsTable,
          DailyLogRow,
          $$DailyLogsTableFilterComposer,
          $$DailyLogsTableOrderingComposer,
          $$DailyLogsTableAnnotationComposer,
          $$DailyLogsTableCreateCompanionBuilder,
          $$DailyLogsTableUpdateCompanionBuilder,
          (
            DailyLogRow,
            BaseReferences<_$DonzelaDatabase, $DailyLogsTable, DailyLogRow>,
          ),
          DailyLogRow,
          PrefetchHooks Function()
        > {
  $$DailyLogsTableTableManager(_$DonzelaDatabase db, $DailyLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<String> flow = const Value.absent(),
                Value<String> symptoms = const Value.absent(),
                Value<String> mood = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyLogsCompanion(
                id: id,
                date: date,
                loggedAt: loggedAt,
                flow: flow,
                symptoms: symptoms,
                mood: mood,
                note: note,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String date,
                required DateTime loggedAt,
                Value<String> flow = const Value.absent(),
                Value<String> symptoms = const Value.absent(),
                Value<String> mood = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime updatedAt,
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyLogsCompanion.insert(
                id: id,
                date: date,
                loggedAt: loggedAt,
                flow: flow,
                symptoms: symptoms,
                mood: mood,
                note: note,
                updatedAt: updatedAt,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$DonzelaDatabase,
      $DailyLogsTable,
      DailyLogRow,
      $$DailyLogsTableFilterComposer,
      $$DailyLogsTableOrderingComposer,
      $$DailyLogsTableAnnotationComposer,
      $$DailyLogsTableCreateCompanionBuilder,
      $$DailyLogsTableUpdateCompanionBuilder,
      (
        DailyLogRow,
        BaseReferences<_$DonzelaDatabase, $DailyLogsTable, DailyLogRow>,
      ),
      DailyLogRow,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$DonzelaDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$DonzelaDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$DonzelaDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$DonzelaDatabase,
          $SettingsTable,
          SettingRow,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (
            SettingRow,
            BaseReferences<_$DonzelaDatabase, $SettingsTable, SettingRow>,
          ),
          SettingRow,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$DonzelaDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$DonzelaDatabase,
      $SettingsTable,
      SettingRow,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (
        SettingRow,
        BaseReferences<_$DonzelaDatabase, $SettingsTable, SettingRow>,
      ),
      SettingRow,
      PrefetchHooks Function()
    >;
typedef $$ArticlesTableCreateCompanionBuilder =
    ArticlesCompanion Function({
      required String id,
      required String lang,
      required String category,
      required String title,
      required String body,
      Value<String?> reviewedBy,
      Value<DateTime?> reviewedOn,
      Value<DateTime?> createdAt,
      Value<String?> author,
      Value<String?> proposedReviewer,
      required DateTime updatedAt,
      Value<bool> saved,
      Value<int> rowid,
    });
typedef $$ArticlesTableUpdateCompanionBuilder =
    ArticlesCompanion Function({
      Value<String> id,
      Value<String> lang,
      Value<String> category,
      Value<String> title,
      Value<String> body,
      Value<String?> reviewedBy,
      Value<DateTime?> reviewedOn,
      Value<DateTime?> createdAt,
      Value<String?> author,
      Value<String?> proposedReviewer,
      Value<DateTime> updatedAt,
      Value<bool> saved,
      Value<int> rowid,
    });

class $$ArticlesTableFilterComposer
    extends Composer<_$DonzelaDatabase, $ArticlesTable> {
  $$ArticlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewedBy => $composableBuilder(
    column: $table.reviewedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reviewedOn => $composableBuilder(
    column: $table.reviewedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get proposedReviewer => $composableBuilder(
    column: $table.proposedReviewer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get saved => $composableBuilder(
    column: $table.saved,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ArticlesTableOrderingComposer
    extends Composer<_$DonzelaDatabase, $ArticlesTable> {
  $$ArticlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewedBy => $composableBuilder(
    column: $table.reviewedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reviewedOn => $composableBuilder(
    column: $table.reviewedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get proposedReviewer => $composableBuilder(
    column: $table.proposedReviewer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get saved => $composableBuilder(
    column: $table.saved,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ArticlesTableAnnotationComposer
    extends Composer<_$DonzelaDatabase, $ArticlesTable> {
  $$ArticlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lang =>
      $composableBuilder(column: $table.lang, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get reviewedBy => $composableBuilder(
    column: $table.reviewedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get reviewedOn => $composableBuilder(
    column: $table.reviewedOn,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get proposedReviewer => $composableBuilder(
    column: $table.proposedReviewer,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get saved =>
      $composableBuilder(column: $table.saved, builder: (column) => column);
}

class $$ArticlesTableTableManager
    extends
        RootTableManager<
          _$DonzelaDatabase,
          $ArticlesTable,
          ArticleRow,
          $$ArticlesTableFilterComposer,
          $$ArticlesTableOrderingComposer,
          $$ArticlesTableAnnotationComposer,
          $$ArticlesTableCreateCompanionBuilder,
          $$ArticlesTableUpdateCompanionBuilder,
          (
            ArticleRow,
            BaseReferences<_$DonzelaDatabase, $ArticlesTable, ArticleRow>,
          ),
          ArticleRow,
          PrefetchHooks Function()
        > {
  $$ArticlesTableTableManager(_$DonzelaDatabase db, $ArticlesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArticlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArticlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArticlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> lang = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String?> reviewedBy = const Value.absent(),
                Value<DateTime?> reviewedOn = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> proposedReviewer = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> saved = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArticlesCompanion(
                id: id,
                lang: lang,
                category: category,
                title: title,
                body: body,
                reviewedBy: reviewedBy,
                reviewedOn: reviewedOn,
                createdAt: createdAt,
                author: author,
                proposedReviewer: proposedReviewer,
                updatedAt: updatedAt,
                saved: saved,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String lang,
                required String category,
                required String title,
                required String body,
                Value<String?> reviewedBy = const Value.absent(),
                Value<DateTime?> reviewedOn = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> proposedReviewer = const Value.absent(),
                required DateTime updatedAt,
                Value<bool> saved = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ArticlesCompanion.insert(
                id: id,
                lang: lang,
                category: category,
                title: title,
                body: body,
                reviewedBy: reviewedBy,
                reviewedOn: reviewedOn,
                createdAt: createdAt,
                author: author,
                proposedReviewer: proposedReviewer,
                updatedAt: updatedAt,
                saved: saved,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ArticlesTableProcessedTableManager =
    ProcessedTableManager<
      _$DonzelaDatabase,
      $ArticlesTable,
      ArticleRow,
      $$ArticlesTableFilterComposer,
      $$ArticlesTableOrderingComposer,
      $$ArticlesTableAnnotationComposer,
      $$ArticlesTableCreateCompanionBuilder,
      $$ArticlesTableUpdateCompanionBuilder,
      (
        ArticleRow,
        BaseReferences<_$DonzelaDatabase, $ArticlesTable, ArticleRow>,
      ),
      ArticleRow,
      PrefetchHooks Function()
    >;
typedef $$HealthCentresTableCreateCompanionBuilder =
    HealthCentresCompanion Function({
      required String id,
      required String district,
      required String sector,
      required String name,
      required String phone,
      required String services,
      Value<int> rowid,
    });
typedef $$HealthCentresTableUpdateCompanionBuilder =
    HealthCentresCompanion Function({
      Value<String> id,
      Value<String> district,
      Value<String> sector,
      Value<String> name,
      Value<String> phone,
      Value<String> services,
      Value<int> rowid,
    });

class $$HealthCentresTableFilterComposer
    extends Composer<_$DonzelaDatabase, $HealthCentresTable> {
  $$HealthCentresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sector => $composableBuilder(
    column: $table.sector,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get services => $composableBuilder(
    column: $table.services,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HealthCentresTableOrderingComposer
    extends Composer<_$DonzelaDatabase, $HealthCentresTable> {
  $$HealthCentresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get district => $composableBuilder(
    column: $table.district,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sector => $composableBuilder(
    column: $table.sector,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get services => $composableBuilder(
    column: $table.services,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HealthCentresTableAnnotationComposer
    extends Composer<_$DonzelaDatabase, $HealthCentresTable> {
  $$HealthCentresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get district =>
      $composableBuilder(column: $table.district, builder: (column) => column);

  GeneratedColumn<String> get sector =>
      $composableBuilder(column: $table.sector, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get services =>
      $composableBuilder(column: $table.services, builder: (column) => column);
}

class $$HealthCentresTableTableManager
    extends
        RootTableManager<
          _$DonzelaDatabase,
          $HealthCentresTable,
          HealthCentreRow,
          $$HealthCentresTableFilterComposer,
          $$HealthCentresTableOrderingComposer,
          $$HealthCentresTableAnnotationComposer,
          $$HealthCentresTableCreateCompanionBuilder,
          $$HealthCentresTableUpdateCompanionBuilder,
          (
            HealthCentreRow,
            BaseReferences<
              _$DonzelaDatabase,
              $HealthCentresTable,
              HealthCentreRow
            >,
          ),
          HealthCentreRow,
          PrefetchHooks Function()
        > {
  $$HealthCentresTableTableManager(
    _$DonzelaDatabase db,
    $HealthCentresTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthCentresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthCentresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HealthCentresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> district = const Value.absent(),
                Value<String> sector = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> services = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HealthCentresCompanion(
                id: id,
                district: district,
                sector: sector,
                name: name,
                phone: phone,
                services: services,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String district,
                required String sector,
                required String name,
                required String phone,
                required String services,
                Value<int> rowid = const Value.absent(),
              }) => HealthCentresCompanion.insert(
                id: id,
                district: district,
                sector: sector,
                name: name,
                phone: phone,
                services: services,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HealthCentresTableProcessedTableManager =
    ProcessedTableManager<
      _$DonzelaDatabase,
      $HealthCentresTable,
      HealthCentreRow,
      $$HealthCentresTableFilterComposer,
      $$HealthCentresTableOrderingComposer,
      $$HealthCentresTableAnnotationComposer,
      $$HealthCentresTableCreateCompanionBuilder,
      $$HealthCentresTableUpdateCompanionBuilder,
      (
        HealthCentreRow,
        BaseReferences<_$DonzelaDatabase, $HealthCentresTable, HealthCentreRow>,
      ),
      HealthCentreRow,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      required String targetTable,
      required String recordId,
      required String action,
      required DateTime createdAt,
      Value<bool> synced,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      Value<String> targetTable,
      Value<String> recordId,
      Value<String> action,
      Value<DateTime> createdAt,
      Value<bool> synced,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$DonzelaDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
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

  ColumnFilters<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$DonzelaDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
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

  ColumnOrderings<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$DonzelaDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$DonzelaDatabase,
          $SyncQueueTable,
          SyncQueueRow,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueRow,
            BaseReferences<_$DonzelaDatabase, $SyncQueueTable, SyncQueueRow>,
          ),
          SyncQueueRow,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$DonzelaDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> targetTable = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> synced = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                targetTable: targetTable,
                recordId: recordId,
                action: action,
                createdAt: createdAt,
                synced: synced,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String targetTable,
                required String recordId,
                required String action,
                required DateTime createdAt,
                Value<bool> synced = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                targetTable: targetTable,
                recordId: recordId,
                action: action,
                createdAt: createdAt,
                synced: synced,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$DonzelaDatabase,
      $SyncQueueTable,
      SyncQueueRow,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueRow,
        BaseReferences<_$DonzelaDatabase, $SyncQueueTable, SyncQueueRow>,
      ),
      SyncQueueRow,
      PrefetchHooks Function()
    >;
typedef $$ContentOutboxTableCreateCompanionBuilder =
    ContentOutboxCompanion Function({
      Value<int> id,
      required String kind,
      required String payload,
      required DateTime createdAt,
    });
typedef $$ContentOutboxTableUpdateCompanionBuilder =
    ContentOutboxCompanion Function({
      Value<int> id,
      Value<String> kind,
      Value<String> payload,
      Value<DateTime> createdAt,
    });

class $$ContentOutboxTableFilterComposer
    extends Composer<_$DonzelaDatabase, $ContentOutboxTable> {
  $$ContentOutboxTableFilterComposer({
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

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ContentOutboxTableOrderingComposer
    extends Composer<_$DonzelaDatabase, $ContentOutboxTable> {
  $$ContentOutboxTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ContentOutboxTableAnnotationComposer
    extends Composer<_$DonzelaDatabase, $ContentOutboxTable> {
  $$ContentOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ContentOutboxTableTableManager
    extends
        RootTableManager<
          _$DonzelaDatabase,
          $ContentOutboxTable,
          ContentOutboxRow,
          $$ContentOutboxTableFilterComposer,
          $$ContentOutboxTableOrderingComposer,
          $$ContentOutboxTableAnnotationComposer,
          $$ContentOutboxTableCreateCompanionBuilder,
          $$ContentOutboxTableUpdateCompanionBuilder,
          (
            ContentOutboxRow,
            BaseReferences<
              _$DonzelaDatabase,
              $ContentOutboxTable,
              ContentOutboxRow
            >,
          ),
          ContentOutboxRow,
          PrefetchHooks Function()
        > {
  $$ContentOutboxTableTableManager(
    _$DonzelaDatabase db,
    $ContentOutboxTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ContentOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ContentOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ContentOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ContentOutboxCompanion(
                id: id,
                kind: kind,
                payload: payload,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String kind,
                required String payload,
                required DateTime createdAt,
              }) => ContentOutboxCompanion.insert(
                id: id,
                kind: kind,
                payload: payload,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ContentOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$DonzelaDatabase,
      $ContentOutboxTable,
      ContentOutboxRow,
      $$ContentOutboxTableFilterComposer,
      $$ContentOutboxTableOrderingComposer,
      $$ContentOutboxTableAnnotationComposer,
      $$ContentOutboxTableCreateCompanionBuilder,
      $$ContentOutboxTableUpdateCompanionBuilder,
      (
        ContentOutboxRow,
        BaseReferences<
          _$DonzelaDatabase,
          $ContentOutboxTable,
          ContentOutboxRow
        >,
      ),
      ContentOutboxRow,
      PrefetchHooks Function()
    >;

class $DonzelaDatabaseManager {
  final _$DonzelaDatabase _db;
  $DonzelaDatabaseManager(this._db);
  $$CyclesTableTableManager get cycles =>
      $$CyclesTableTableManager(_db, _db.cycles);
  $$DailyLogsTableTableManager get dailyLogs =>
      $$DailyLogsTableTableManager(_db, _db.dailyLogs);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$ArticlesTableTableManager get articles =>
      $$ArticlesTableTableManager(_db, _db.articles);
  $$HealthCentresTableTableManager get healthCentres =>
      $$HealthCentresTableTableManager(_db, _db.healthCentres);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$ContentOutboxTableTableManager get contentOutbox =>
      $$ContentOutboxTableTableManager(_db, _db.contentOutbox);
}

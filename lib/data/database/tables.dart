import 'package:drift/drift.dart';

/// One period, from its first day. Cycle length is derived from the next
/// start and stored so history and exports are fast.
@DataClassName('CycleRow')
class Cycles extends Table {
  TextColumn get id => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  IntColumn get periodLength => integer()();
  IntColumn get cycleLength => integer().nullable()();
  BoolColumn get isEstimate => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// One entry in the log. A day can have many entries, each with its own
/// time, so the day is indexed rather than unique.
@DataClassName('DailyLogRow')
class DailyLogs extends Table {
  TextColumn get id => text()();
  TextColumn get date => text()(); // yyyy-MM-dd, local day of the entry
  DateTimeColumn get loggedAt => dateTime()(); // full date and time of the entry
  TextColumn get flow => text().withDefault(const Constant('none'))();
  TextColumn get symptoms => text().withDefault(const Constant('[]'))();
  TextColumn get mood => text().withDefault(const Constant('[]'))();
  TextColumn get note => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SettingRow')
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('ArticleRow')
class Articles extends Table {
  TextColumn get id => text()();
  TextColumn get lang => text()();
  TextColumn get category => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get reviewedBy => text().nullable()();
  DateTimeColumn get reviewedOn => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get saved => boolean().withDefault(const Constant(false))();

  /// One article per language: the same id exists in rw, en and fr.
  @override
  Set<Column> get primaryKey => {id, lang};
}

@DataClassName('HealthCentreRow')
class HealthCentres extends Table {
  TextColumn get id => text()();
  TextColumn get district => text()();
  TextColumn get sector => text()();
  TextColumn get name => text()();
  TextColumn get phone => text()();
  TextColumn get services => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Outgoing changes waiting to reach the cloud. Every local write adds one.
@DataClassName('SyncQueueRow')
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get targetTable => text().named('table_name')();
  TextColumn get recordId => text()();
  TextColumn get action => text()(); // upsert | delete
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
}

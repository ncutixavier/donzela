// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daos.dart';

// ignore_for_file: type=lint
mixin _$CyclesDaoMixin on DatabaseAccessor<DonzelaDatabase> {
  $CyclesTable get cycles => attachedDatabase.cycles;
  CyclesDaoManager get managers => CyclesDaoManager(this);
}

class CyclesDaoManager {
  final _$CyclesDaoMixin _db;
  CyclesDaoManager(this._db);
  $$CyclesTableTableManager get cycles =>
      $$CyclesTableTableManager(_db.attachedDatabase, _db.cycles);
}

mixin _$DailyLogsDaoMixin on DatabaseAccessor<DonzelaDatabase> {
  $DailyLogsTable get dailyLogs => attachedDatabase.dailyLogs;
  DailyLogsDaoManager get managers => DailyLogsDaoManager(this);
}

class DailyLogsDaoManager {
  final _$DailyLogsDaoMixin _db;
  DailyLogsDaoManager(this._db);
  $$DailyLogsTableTableManager get dailyLogs =>
      $$DailyLogsTableTableManager(_db.attachedDatabase, _db.dailyLogs);
}

mixin _$SettingsDaoMixin on DatabaseAccessor<DonzelaDatabase> {
  $SettingsTable get settings => attachedDatabase.settings;
  SettingsDaoManager get managers => SettingsDaoManager(this);
}

class SettingsDaoManager {
  final _$SettingsDaoMixin _db;
  SettingsDaoManager(this._db);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db.attachedDatabase, _db.settings);
}

mixin _$ContentDaoMixin on DatabaseAccessor<DonzelaDatabase> {
  $ArticlesTable get articles => attachedDatabase.articles;
  $HealthCentresTable get healthCentres => attachedDatabase.healthCentres;
  ContentDaoManager get managers => ContentDaoManager(this);
}

class ContentDaoManager {
  final _$ContentDaoMixin _db;
  ContentDaoManager(this._db);
  $$ArticlesTableTableManager get articles =>
      $$ArticlesTableTableManager(_db.attachedDatabase, _db.articles);
  $$HealthCentresTableTableManager get healthCentres =>
      $$HealthCentresTableTableManager(_db.attachedDatabase, _db.healthCentres);
}

mixin _$SyncQueueDaoMixin on DatabaseAccessor<DonzelaDatabase> {
  $SyncQueueTable get syncQueue => attachedDatabase.syncQueue;
  SyncQueueDaoManager get managers => SyncQueueDaoManager(this);
}

class SyncQueueDaoManager {
  final _$SyncQueueDaoMixin _db;
  SyncQueueDaoManager(this._db);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db.attachedDatabase, _db.syncQueue);
}

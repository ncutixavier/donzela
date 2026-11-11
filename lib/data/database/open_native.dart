import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Phone and desktop: a SQLite file in the app documents folder.
QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'donzela.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

/// In-memory database for tests.
QueryExecutor openMemory() => NativeDatabase.memory();

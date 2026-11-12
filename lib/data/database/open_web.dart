import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// Web: SQLite compiled to WebAssembly, stored in the browser. The files
/// `sqlite3.wasm` and `drift_worker.js` are served from the web folder.
QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final result = await WasmDatabase.open(
      databaseName: 'donzela',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );
    return result.resolvedExecutor;
  });
}

/// Tests run on the VM, so the web build never uses this.
QueryExecutor openMemory() => throw UnsupportedError('In-memory database is for tests');

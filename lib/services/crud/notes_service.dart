import 'package:flutternotes/services/crud/constants/db_column.dart';
import 'package:flutternotes/services/crud/constants/db_ddl_query.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class NotesService {
  Database? _db;

  Database _getDatabaseorThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DbAlreadyOpenException;
    }
    try {
      // Initialize DB
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      // Create user table if not exists
      await db.execute(createUserTable);

      // Create note table if not exists
      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw DbCannotBeOpenedExcetion();
    }
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseorThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (deletedCount != 1) {
      throw CouldNotDeleteUserException;
    }
  }

  Future<void> insertUser({required String email}) async {}
}

// Exception
class DbCannotBeOpenedExcetion implements Exception {}

class DbAlreadyOpenException implements Exception {}

class DatabaseIsNotOpen implements Exception {}

class CouldNotDeleteUserException implements Exception {}

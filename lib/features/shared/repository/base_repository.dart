import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:sqlite3/sqlite3.dart';

abstract class BaseRepository {
  static Database? _database;

  Database get database {
    _database ??= _initDatabase();
    return _database!;
  }

  static Database _initDatabase() {
    final dbPath = path.join(Directory.current.path, 'taskboard.db');
    final db = sqlite3.open(dbPath);
    _createTables(db);
    return db;
  }

  static void _createTables(Database db) {
    db
      ..execute('''
      CREATE TABLE IF NOT EXISTS users (
        id TEXT PRIMARY KEY,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL,
        username TEXT NOT NULL,
        dateCreated TEXT,
        lastUpdated TEXT,
      )
    ''')
      ..execute('''
      CREATE TABLE IF NOT EXISTS workspaces (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        owner TEXT NOT NULL,
        members TEXT NOT NULL,
        dateCreated TEXT,
        lastUpdated TEXT,
        FOREIGN KEY (owner) REFERENCES users (id)
      )
    ''')
      ..execute('''
      CREATE TABLE IF NOT EXISTS columns (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        workspace TEXT NOT NULL,
        order INTEGER NOT NULL,
        dateCreated TEXT,
        lastUpdated TEXT,
        FOREIGN KEY (workspace) REFERENCES workspaces (id)
      )
    ''')
      ..execute('''
      CREATE TABLE IF NOT EXISTS tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        column TEXT NOT NULL,
        assignee TEXT NOT NULL,
        deadline TEXT,
        tags TEXT NOT NULL,
        order INTEGER NOT NULL,
        dateCreated TEXT,
        lastUpdated TEXT,
        FOREIGN KEY (column) REFERENCES columns (id),
        FOREIGN KEY (assignee) REFERENCES users (id)
      )
    ''')
      ..execute('''
      CREATE TABLE IF NOT EXISTS comments (
        id TEXT PRIMARY KEY,
        task TEXT NOT NULL,
        author TEXT NOT NULL,
        content TEXT NOT NULL,
        dateCreated TEXT,
        lastUpdated TEXT,
        FOREIGN KEY (task) REFERENCES tasks (id),
        FOREIGN KEY (author) REFERENCES users (id)
      )
    ''');
  }
}

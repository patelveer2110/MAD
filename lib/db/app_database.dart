// lib/db/app_database.dart

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/grade.dart';

class AppDatabase {
  AppDatabase._privateConstructor();
  static final AppDatabase instance = AppDatabase._privateConstructor();

  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    await init();
    return _db!;
  }

  /// Initialize the SQLite database
  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "grade_tracker.db");

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE grades(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        courseCode TEXT NOT NULL,
        assessmentType TEXT NOT NULL,
        maxMarks REAL NOT NULL,
        obtainedMarks REAL NOT NULL,
        date TEXT NOT NULL,
        remarks TEXT,
        scannedFilePath TEXT,
        term TEXT
      )
    ''');
  }

  // ---------------------------------------------------------------
  // CRUD METHODS FOR Grade MODEL
  // ---------------------------------------------------------------

  /// Insert a new grade
  Future<int> insertGrade(Grade grade) async {
    final db = await database;
    return await db.insert(
      'grades',
      grade.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Fetch all grades
  Future<List<Grade>> getAllGrades() async {
    final db = await database;
    final data = await db.query(
      'grades',
      orderBy: "date DESC",
    );

    return data.map((map) => Grade.fromMap(map)).toList();
  }

  /// Fetch grades for a specific course
  Future<List<Grade>> getGradesByCourse(String courseCode) async {
    final db = await database;
    final data = await db.query(
      'grades',
      where: 'courseCode = ?',
      whereArgs: [courseCode],
      orderBy: "date DESC",
    );

    return data.map((map) => Grade.fromMap(map)).toList();
  }

  /// Fetch grades by term (Semester)
  Future<List<Grade>> getGradesByTerm(String term) async {
    final db = await database;
    final data = await db.query(
      'grades',
      where: 'term = ?',
      whereArgs: [term],
      orderBy: "date DESC",
    );

    return data.map((map) => Grade.fromMap(map)).toList();
  }

  /// Update an existing grade
  Future<int> updateGrade(Grade grade) async {
    final db = await database;
    return await db.update(
      'grades',
      grade.toMap(),
      where: 'id = ?',
      whereArgs: [grade.id],
    );
  }

  /// Delete a grade by ID
  Future<int> deleteGrade(int id) async {
    final db = await database;
    return await db.delete(
      'grades',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete all grades (optional helper)
  Future<void> deleteAllGrades() async {
    final db = await database;
    await db.delete('grades');
  }
}

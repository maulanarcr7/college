import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqlite_api.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;
  static bool _initialized = false;

  DatabaseHelper._internal() {
    _initSqflite();
  }

  Future<void> _initSqflite() async {
    if (!_initialized) {
      sqfliteFfiInit();
      final databaseFactory = databaseFactoryFfi;
      _initialized = true;
    }
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'college.db');

    return await databaseFactory.openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE students (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            gender TEXT,
            phone TEXT
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAllStudents() async {
    final db = await database;
    return await db.query('students');
  }

  Future<void> insertStudent(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert('students', data);
  }

  Future<void> updateStudent(int id, Map<String, dynamic> data) async {
    final db = await database;
    await db.update('students', data, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteStudent(int id) async {
    final db = await database;
    await db.delete('students', where: 'id = ?', whereArgs: [id]);
  }
}

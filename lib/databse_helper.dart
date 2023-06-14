import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'db_college.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('CREATE TABLE data_mhs ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT, '
        'name TEXT, '
        'gender TEXT, '
        'phone_number TEXT'
        ')');
  }

  Future<List<Map<String, dynamic>>> getdata_mhs() async {
    final Database db = await database;
    return db.query('data_mhs');
  }

  Future<int> insertStudent(Map<String, dynamic> student) async {
    final Database db = await database;
    return db.insert('data_mhs', student);
  }

  Future<int> updateStudent(Map<String, dynamic> student) async {
    final Database db = await database;
    return db.update(
      'data_mhs',
      student,
      where: 'id = ?',
      whereArgs: [student['id']],
    );
  }

  Future<int> deleteStudent(int id) async {
    final Database db = await database;
    return db.delete(
      'data_mhs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

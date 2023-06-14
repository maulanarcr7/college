import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'College App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Database? _database;
  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _initSqflite();
  }

  void _initSqflite() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'college.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: _onDatabaseCreate,
    );
    await _database?.execute('PRAGMA foreign_keys = ON');
    openDatabaseAndLoadData();
  }

  Future<void> _onDatabaseCreate(Database db, int version) async {
    await db.execute('CREATE TABLE IF NOT EXISTS students ('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'name TEXT,'
        'gender TEXT,'
        'phone_number TEXT'
        ')');
  }

  Future<void> openDatabaseAndLoadData() async {
    if (_database == null) return;
    _data = await _database!.rawQuery('SELECT * FROM students');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: _data.isNotEmpty
            ? DataTable(
                columns: const <DataColumn>[
                  DataColumn(label: Text('No')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Gender')),
                  DataColumn(label: Text('Phone Number')),
                ],
                rows: List<DataRow>.generate(
                  _data.length,
                  (index) {
                    final item = _data[index];
                    return DataRow(
                      cells: [
                        DataCell(Text(item['id'].toString())),
                        DataCell(Text(item['name'])),
                        DataCell(Text(item['gender'])),
                        DataCell(Text(item['phone_number'])),
                      ],
                    );
                  },
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}

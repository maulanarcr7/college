import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'College App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Database? _database;
  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    openDatabaseAndLoadData();
  }

  Future<void> openDatabaseAndLoadData() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'db_college.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute('CREATE TABLE data_mhs ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'name TEXT, '
            'gender TEXT, '
            'phone_number TEXT'
            ')');
      },
    );

    _data = await _database!.rawQuery('SELECT * FROM data_mhs');

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
                        DataCell(Text(item['name'].toString())),
                        DataCell(Text(item['gender'].toString())),
                        DataCell(Text(item['phone_number'].toString())),
                      ],
                    );
                  },
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}

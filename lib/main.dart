import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'database_helper.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that Flutter is initialized
  final databaseHelper = DatabaseHelper();
  await databaseHelper.database; // Initialize the database

  runApp(MyApp(databaseHelper: databaseHelper));
}

class MyApp extends StatelessWidget {
  final DatabaseHelper databaseHelper;

  const MyApp({required this.databaseHelper});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'College App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(databaseHelper: databaseHelper),
    );
  }
}

class HomePage extends StatefulWidget {
  final DatabaseHelper databaseHelper;

  const HomePage({required this.databaseHelper});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final allStudents = await widget.databaseHelper.getAllStudents();
    setState(() {
      students = allStudents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('College App'),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return ListTile(
            leading: Text(student['id'].toString()),
            title: Text(student['name']),
            subtitle: Text(student['gender']),
            trailing: Text(student['phone']),
          );
        },
      ),
    );
  }
}

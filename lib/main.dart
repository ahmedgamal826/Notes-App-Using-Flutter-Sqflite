import 'package:flutter/material.dart';
import 'package:notes_app_sqflite/database.dart';
import 'package:notes_app_sqflite/notes_app_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SqfliteDatabase.initialiseDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

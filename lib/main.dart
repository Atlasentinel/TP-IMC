import 'package:flutter/material.dart';
import 'body_mass_index.dart'; // Import du fichier contenant le formulaire

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMC Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 20.0),
        ),
      ),
      home: const Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: BMIForm(),
        ),
      ),
    );
  }
}

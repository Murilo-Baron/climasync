import 'package:flutter/material.dart';
import '../models/weather_model.dart';  // Importe o modelo Weather
import 'screens/home_screen.dart'; // Importe o arquivo onde a HomeScreen está definida

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(), // Use HomeScreen como tela inicial
    );
  }
}

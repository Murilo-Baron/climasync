import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Importe o arquivo onde a HomeScreen está definida
import 'package:intl/date_symbol_data_local.dart'; // Importe o modelo Weather

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(); // Inicializa o formato de data
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(), // Use HomeScreen como tela inicial
    );
  }
}

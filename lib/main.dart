import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/date_symbol_data_local.dart'; // Para formatação de data
import 'screens/home_screen.dart'; // Importa o arquivo onde a HomeScreen está definida

void main() async {
  debugPaintSizeEnabled = false; // Disable the debug banner
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting(); // Inicializa o formato de data
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen(), // Define HomeScreen como tela inicial
    );
  }
}
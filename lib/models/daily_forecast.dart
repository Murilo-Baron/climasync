import 'package:intl/intl.dart';

class DailyForecast {
  final String day;
  final DateTime date;
  final double temperature;
  final double temperatureMin; 
  final double temperatureMax;
  final String weatherDescription; // Novo campo para a descrição do clima

  DailyForecast({
    required this.day,
    required this.date,
    required this.temperature,
    required this.temperatureMin,
    required this.temperatureMax,
    required this.weatherDescription, // Inicializando weatherDescription
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    final day = json['day'] ?? 'Desconhecido';
    final dateString = json['dt_txt'] as String? ?? '';
    final date = DateTime.tryParse(dateString.split(' ').first) ?? DateTime.now();
    final temperature = (json['main']['temp'] as num?)?.toDouble() ?? 0.0;
    final temperatureMin = (json['main']['temp_min'] as num?)?.toDouble() ?? 0.0;
    final temperatureMax = (json['main']['temp_max'] as num?)?.toDouble() ?? 0.0;

    // Extraindo a descrição do clima da resposta JSON
    final weatherDescription = (json['weather'] != null && json['weather'].isNotEmpty) 
      ? json['weather'][0]['description'] as String
      : 'Desconhecido';

    return DailyForecast(
      day: day,
      date: date,
      temperature: temperature,
      temperatureMin: temperatureMin,
      temperatureMax: temperatureMax,
      weatherDescription: weatherDescription, // Passando weatherDescription para o construtor
    );
  }

  String get description {
    String formattedDate = DateFormat("dd/MM/yyyy").format(date);
    return 'Dia: $day, Data: $formattedDate, Clima: $weatherDescription, Temperatura: ${temperature.toStringAsFixed(1)}°C, Mínima: ${temperatureMin.toStringAsFixed(1)}°C, Máxima: ${temperatureMax.toStringAsFixed(1)}°C';
  }

  DateTime get dateTime => date;
}

import 'package:intl/intl.dart'; // Importando o pacote intl

class DailyForecast {
  final String day;
  final DateTime date;
  final double temperature;
  final double maxTemperature; // Adicionando o campo maxTemperature
  final double minTemperature; // Adicionando o campo minTemperature

  DailyForecast({
    required this.day,
    required this.date,
    required this.temperature,
    required this.maxTemperature,
    required this.minTemperature,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    final day = json['day'] ?? 'Desconhecido'; // Valor padrão se 'day' for nulo
    final dateString = json['dt_txt'] as String? ?? '';
    final date = DateTime.tryParse(dateString.split(' ').first) ?? DateTime.now();
    final temperature = (json['main']['temp'] as num?)?.toDouble() ?? 0.0;
    final maxTemperature = (json['main']['temp_max'] as num?)?.toDouble() ?? 0.0;
    final minTemperature = (json['main']['temp_min'] as num?)?.toDouble() ?? 0.0;

    return DailyForecast(
      day: day,
      date: date,
      temperature: temperature,
      maxTemperature: maxTemperature,
      minTemperature: minTemperature,
    );
  }

  // Getter para fornecer uma descrição legível
  String get description {
    String formattedDate = DateFormat("dd/MM/yyyy").format(date);
    return 'Dia: $day, Data: $formattedDate, Temperatura: ${temperature.toStringAsFixed(1)}°C, Máxima: ${maxTemperature.toStringAsFixed(1)}°C, Mínima: ${minTemperature.toStringAsFixed(1)}°C';
  }

  // Getter para fornecer a data como DateTime
  DateTime get dateTime => date;
}

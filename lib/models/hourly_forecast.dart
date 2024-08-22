import 'package:intl/intl.dart'; // Importando o pacote intl

class HourlyForecast {
  final String time;
  final double temperature;

  HourlyForecast({required this.time, required this.temperature});

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: json['dt_txt'] as String? ?? '', // Acessa a chave 'dt_txt' para a data e hora
      temperature: (json['main']['temp'] as num?)?.toDouble() ?? 0.0, // Acessa a chave 'main.temp' para a temperatura
    );
  }

  // Método para converter a string time em um objeto DateTime
  DateTime get dateTime => DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);
}

import 'package:intl/intl.dart';

class HourlyForecast {
  final String time;
  final double temperature;
  final double temperatureMin;
  final double temperatureMax;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.temperatureMin,
    required this.temperatureMax,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: json['dt_txt'] as String? ?? '',
      temperature: (json['main']['temp'] as num?)?.toDouble() ?? 0.0,
      temperatureMin: (json['main']['temp_min'] as num?)?.toDouble() ?? 0.0,
      temperatureMax: (json['main']['temp_max'] as num?)?.toDouble() ?? 0.0,
    );
  }

  DateTime get dateTime => DateFormat("yyyy-MM-dd HH:mm:ss").parse(time);

  String get description {
    String formattedDate = DateFormat("dd/MM/yyyy HH:mm").format(dateTime);
    return 'Data e Hora: $formattedDate, Temperatura: ${temperature.toStringAsFixed(1)}°C, Mínima: ${temperatureMin.toStringAsFixed(1)}°C, Máxima: ${temperatureMax.toStringAsFixed(1)}°C';
  }

  // Método para obter o caminho do ícone com base na temperatura
  String getTemperatureIcon() {
    if (temperature <= 10) {
      return 'assets/icon/freezing.png';
    } else if (temperature <= 20) {
      return 'assets/icon/loss.png';
    } else if (temperature <= 30) {
      return 'assets/icon/warm.png';
    } else {
      return 'assets/icon/hot.png';
    }
  }
}

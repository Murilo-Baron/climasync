class HourlyForecast {
  final String time;
  final double temperature;

  HourlyForecast({required this.time, required this.temperature});

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: json['dt_txt'] as String? ?? '', // Corrigido para acessar a chave correta
      temperature: (json['main']['temp'] as num?)?.toDouble() ?? 0.0, // Corrigido para acessar a chave correta
    );
  }
}

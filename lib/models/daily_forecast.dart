class DailyForecast {
  final String day;
  final DateTime date;
  final double temperature;

  DailyForecast({
    required this.day,
    required this.date,
    required this.temperature,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      day: json['day'],
      date: DateTime.parse(json['dt_txt']?.split(' ')?.first ?? ''), // Converte a string para DateTime
      temperature: (json['main']['temp'] ?? 0).toDouble(), // Converte para double, mesmo se for null
    );
  }
}

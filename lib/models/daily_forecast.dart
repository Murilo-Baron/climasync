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
    // Acessa a chave 'day' e garante que é uma string não nula
    final day = json['day'] ?? 'Desconhecido'; // Valor padrão se 'day' for nulo

    // Acessa a chave 'dt_txt', divide e faz parse para DateTime
    final dateString = json['dt_txt'] as String? ?? '';
    final date = DateTime.tryParse(dateString.split(' ').first) ?? DateTime.now();

    // Acessa a chave 'temp', garante que é um double não nulo
    final temperature = (json['main']['temp'] as num?)?.toDouble() ?? 0.0;

    return DailyForecast(
      day: day,
      date: date,
      temperature: temperature,
    );
  }
}

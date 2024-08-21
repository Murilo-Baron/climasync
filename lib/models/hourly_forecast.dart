class HourlyForecast {
  final String time;
  final double temperature;

  HourlyForecast({required this.time, required this.temperature});

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    return HourlyForecast(
      time: json['time'],
      temperature: json['temperature'].toDouble(),
    );
  }
}



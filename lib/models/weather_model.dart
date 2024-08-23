class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity; // Propriedade de umidade
  final double windSpeed; // Propriedade de velocidade do vento
  final double feelsLike; // Propriedade de sensação térmica
  final int pressure; // Propriedade de pressão

  var uvIndex; // Propriedade de índice UV (não utilizada no exemplo, mas presente)

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
    required this.pressure, // Adiciona a pressão no construtor
  });

  

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: (json['main']['temp'] as num?)?.toDouble() ?? 0.0,
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (json['main']['feels_like'] as num?)?.toDouble() ?? 0.0,
      pressure: (json['main']['pressure'] as num?)?.toInt() ?? 0, // Preenche a pressão
    );
  }
}



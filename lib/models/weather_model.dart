class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity; // Adiciona a propriedade de umidade
  final double windSpeed; // Adiciona a propriedade de velocidade do vento
  final double feelsLike; // Adiciona a propriedade de sensação térmica

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike, 
    required double uvIndex,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'],
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'], // Preenche a umidade
      windSpeed: json['wind']['speed'], // Preenche a velocidade do vento
      feelsLike: json['main']['feels_like'], // Preenche a sensação térmica
      uvIndex: (json['uvIndex'] as num?)?.toDouble() ?? 0.0, // Acessa o uvIndex do JSON
    );
  }

  get uvIndex => null;
}

class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final double feelsLike;
  final int pressure;
  var uvIndex;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
    required this.pressure,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: (json['main']['temp'] as num?)?.toDouble() ?? 0.0,
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (json['main']['feels_like'] as num?)?.toDouble() ?? 0.0,
      pressure: (json['main']['pressure'] as num?)?.toInt() ?? 0,
    );
  }

  // Método para obter informações do tempo, incluindo o ícone e a tradução
  Map<String, String> getWeatherInfo() {
    switch (description.toLowerCase()) {
      case 'clear sky':
        return {'translation': 'Céu limpo', 'iconPath': 'assets/icon/clear_sky.png'};
      case 'few clouds':
        return {'translation': 'Algumas nuvens', 'iconPath': 'assets/icon/few_clouds.png'};
      case 'scattered clouds':
        return {'translation': 'Nuvens dispersas', 'iconPath': 'assets/icon/scattered_clouds.png'};
      case 'broken clouds':
        return {'translation': 'Nuvens quebradas', 'iconPath': 'assets/icon/broken_clouds.png'};
      case 'shower rain':
      case 'moderate rain':
        return {'translation': 'Garoa', 'iconPath': 'assets/icon/shower_rain.png'};
      case 'rain':
        return {'translation': 'Chuva', 'iconPath': 'assets/icon/rain.png'};
      case 'thunderstorm':
        return {'translation': 'Trovoada', 'iconPath': 'assets/icon/thunderstorm.png'};
      case 'snow':
        return {'translation': 'Neve', 'iconPath': 'assets/icon/snow.png'};
      case 'mist':
        return {'translation': 'Névoa', 'iconPath': 'assets/icon/mist.png'};
      case 'light rain':
        return {'translation': 'Chuva leve', 'iconPath': 'assets/icon/light_rain.png'};
      default:
        return {'translation': description, 'iconPath': 'assets/icon/default.png'};
    }
  }
}

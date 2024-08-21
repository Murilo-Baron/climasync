import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../models/hourly_forecast.dart';
import '../models/daily_forecast.dart';

class WeatherService {
  final String apiKey = 'ea8428fca9fd667ca80ec44454d266d8';
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> fetchWeather(String cityName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/weather?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<HourlyForecast>> fetchHourlyForecast(String cityName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/forecast?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['list'];
      // Filtra as previsões para retornar apenas as próximas 8 horas
      final now = DateTime.now();
      return data.where((json) {
        final dateTime = DateTime.parse(json['dt_txt']);
        return dateTime.isAfter(now) && dateTime.isBefore(now.add(Duration(hours: 8)));
      }).map((json) => HourlyForecast.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load hourly forecast data');
    }
  }

  Future<List<DailyForecast>> fetchDailyForecast(String cityName) async {
    final response = await http.get(
      Uri.parse('$baseUrl/forecast?q=$cityName&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['list'];
      // Agrupa por dia e retorna um único valor por dia
      final dailyData = <String, dynamic>{};
      for (var item in data) {
        final date = DateTime.parse(item['dt_txt']).toString().split(' ')[0];
        dailyData[date] = item;
      }
      return dailyData.values.map((json) => DailyForecast.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load daily forecast data');
    }
  }
}

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
      // Retorna todas as previsões futuras disponíveis
      final now = DateTime.now();
      return data.where((json) {
        final dateTime = DateTime.parse(json['dt_txt']);
        return dateTime.isAfter(now);
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
      // Agrupa previsões por dia e calcula a média para o dia inteiro
      final Map<String, List<dynamic>> dailyData = {};

      for (var item in data) {
        final date = DateTime.parse(item['dt_txt']).toString().split(' ')[0];
        if (dailyData.containsKey(date)) {
          dailyData[date]!.add(item);
        } else {
          dailyData[date] = [item];
        }
      }

      return dailyData.values.map((dailyList) {
        // Você pode calcular a média dos dados diários aqui
        // ou pegar uma previsão representativa, como a do meio-dia.
        final day = dailyList.first['dt_txt'].split(' ')[0];
        return DailyForecast.fromJson(dailyList.first);
      }).toList();
    } else {
      throw Exception('Failed to load daily forecast data');
    }
  }

  Future<Weather> fetchWeatherByCoordinates(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Weather.fromJson(json);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<List<HourlyForecast>> fetchHourlyForecastByCoordinates(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('$baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['list'];
      final now = DateTime.now();
      return data.where((json) {
        final dateTime = DateTime.parse(json['dt_txt']);
        return dateTime.isAfter(now);
      }).map((json) => HourlyForecast.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load hourly forecast data');
    }
  }

  Future<List<DailyForecast>> fetchDailyForecastByCoordinates(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('$baseUrl/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['list'];
      final Map<String, List<dynamic>> dailyData = {};

      for (var item in data) {
        final date = DateTime.parse(item['dt_txt']).toString().split(' ')[0];
        if (dailyData.containsKey(date)) {
          dailyData[date]!.add(item);
        } else {
          dailyData[date] = [item];
        }
      }

      return dailyData.values.map((dailyList) {
        final day = dailyList.first['dt_txt'].split(' ')[0];
        return DailyForecast.fromJson(dailyList.first);
      }).toList();
    } else {
      throw Exception('Failed to load daily forecast data');
    }
  }
}

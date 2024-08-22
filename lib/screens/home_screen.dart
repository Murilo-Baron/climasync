import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/hourly_forecast.dart';
import '../models/daily_forecast.dart';
import '../services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Weather? _weather;
  List<HourlyForecast>? _hourlyForecast;
  List<DailyForecast>? _dailyForecast;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Weather weatherData = await _fetchWeather();
      List<HourlyForecast> hourlyData = await _fetchHourlyForecast();
      List<DailyForecast> dailyData = await _fetchDailyForecast();

      setState(() {
        _weather = weatherData;
        _hourlyForecast = hourlyData;
        _dailyForecast = dailyData;
        _isLoading = false;
      });
    } catch (e) {
      print("Erro ao buscar dados: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Weather> _fetchWeather() async {
    try {
      WeatherService weatherService = WeatherService();
      return await weatherService.fetchWeather('São Paulo');
    } catch (e) {
      print("Erro ao buscar dados do clima: $e");
      rethrow;
    }
  }

  Future<List<HourlyForecast>> _fetchHourlyForecast() async {
    try {
      WeatherService weatherService = WeatherService();
      return await weatherService.fetchHourlyForecast('São Paulo');
    } catch (e) {
      print("Erro ao buscar dados da previsão horária: $e");
      rethrow;
    }
  }

  Future<List<DailyForecast>> _fetchDailyForecast() async {
    try {
      WeatherService weatherService = WeatherService();
      return await weatherService.fetchDailyForecast('São Paulo');
    } catch (e) {
      print("Erro ao buscar dados da previsão diária: $e");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clima"),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),
                    SizedBox(height: 20),
                    _buildCurrentWeather(),
                    SizedBox(height: 20),
                    _buildNextHoursForecast(),
                    SizedBox(height: 20),
                    _buildNextDaysForecast(),
                    SizedBox(height: 20),
                    _buildTodayDetails(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Procure por uma localização',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onSubmitted: (value) async {
        setState(() {
          _isLoading = true;
        });
        try {
          Weather weatherData = await WeatherService().fetchWeather(value);
          List<HourlyForecast> hourlyData =
              await WeatherService().fetchHourlyForecast(value);
          List<DailyForecast> dailyData =
              await WeatherService().fetchDailyForecast(value);

          setState(() {
            _weather = weatherData;
            _hourlyForecast = hourlyData;
            _dailyForecast = dailyData;
            _isLoading = false;
          });
        } catch (e) {
          print("Erro ao buscar dados da nova localização: $e");
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
  }

  Widget _buildCurrentWeather() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _weather?.cityName ?? '',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        Text(
          '${_weather?.temperature.toStringAsFixed(1) ?? ''}°C',
          style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
        ),
        Text(
          _weather?.description ?? '',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300),
        ),
      ],
    );
  }

  Widget _buildNextHoursForecast() {
    return Container(
      height: 100,
      child: _hourlyForecast != null
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _hourlyForecast!.length,
              itemBuilder: (context, index) {
                return _buildHourlyForecastItem(_hourlyForecast![index]);
              },
            )
          : Center(child: Text("Sem dados de previsão horária")),
    );
  }

  Widget _buildHourlyForecastItem(HourlyForecast forecast) {
    return Container(
      width: 80,
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(forecast.time, style: TextStyle(fontSize: 14), textAlign: TextAlign.center),
          ),
          Flexible(
            child: Icon(Icons.wb_sunny, size: 24), // Ícone placeholder, substituir por ícone dinâmico
          ),
          Expanded(
            child: Text(
              "${forecast.temperature.toStringAsFixed(1)}°C", 
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextDaysForecast() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: _dailyForecast != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Próximos 7 dias",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Column(
                  children: _dailyForecast!
                      .map((forecast) => _buildDailyForecastItem(forecast))
                      .toList(),
                ),
              ],
            )
          : Center(child: Text("Sem dados de previsão diária")),
    );
  }

  Widget _buildDailyForecastItem(DailyForecast forecast) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${forecast.day}", style: TextStyle(fontSize: 16)),
          Icon(Icons.wb_sunny, size: 24), // Ícone placeholder, substituir por ícone dinâmico
          Text("${forecast.temperature.toStringAsFixed(1)}°C", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildTodayDetails() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Detalhes de hoje",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem("Humidade", "${_weather?.humidity ?? ''}%"),
              _buildDetailItem("Vento", "${_weather?.windSpeed ?? ''} km/h"),
              _buildDetailItem("Sensação Térmica", "${_weather?.feelsLike ?? ''}°C"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 16)),
        SizedBox(height: 5),
        Text(value, style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
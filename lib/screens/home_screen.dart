import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Weather? _weather;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    WeatherService weatherService = WeatherService();
    Weather weatherData = await weatherService.fetchWeather('São Paulo');
    setState(() {
      _weather = weatherData;
      _isLoading = false;
    });
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
        Weather weatherData = await WeatherService().fetchWeather(value);
        setState(() {
          _weather = weatherData;
          _isLoading = false;
        });
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
          '${_weather?.temperature.toStringAsFixed(2) ?? ''}°C',
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
    // Por enquanto, este exemplo utiliza dados estáticos
    // Você pode adaptar para usar os dados da API para previsão horária
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 8, // Supondo 8 horas de previsão
        itemBuilder: (context, index) {
          return _buildHourlyForecastItem();
        },
      ),
    );
  }

  Widget _buildHourlyForecastItem() {
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
          Text("18:00", style: TextStyle(fontSize: 16)),
          Icon(Icons.wb_sunny, size: 24),
          Text("-3°C", style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildNextDaysForecast() {
    // Suponha que você tem uma lista de previsões diárias
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
            "Proximos 7 dias",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDailyForecastItem(),
              _buildDailyForecastItem(),
              _buildDailyForecastItem(),
              _buildDailyForecastItem(),
              _buildDailyForecastItem(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyForecastItem() {
    return Column(
      children: [
        Text("Mon", style: TextStyle(fontSize: 16)),
        Icon(Icons.wb_sunny, size: 24),
        Text("-5°C", style: TextStyle(fontSize: 16)),
      ],
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
              _buildDetailItem(
                  "Temperatura", "${_weather?.feelsLike ?? ''}°C"),
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

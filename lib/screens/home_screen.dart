import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart'; // Para formatar datas
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

  // Mapeamento das descrições de clima de inglês para português
  String translateWeatherDescription(String description) {
    switch (description.toLowerCase()) {
      case 'clear sky':
        return 'Céu limpo';
      case 'few clouds':
        return 'Algumas nuvens';
      case 'scattered clouds':
        return 'Nuvens dispersas';
      case 'broken clouds':
        return 'Nuvens quebradas';
      case 'shower rain':
        return 'Garoa';
      case 'rain':
        return 'Chuva';
      case 'thunderstorm':
        return 'Trovoada';
      case 'snow':
        return 'Neve';
      case 'mist':
        return 'Névoa';
      case 'light rain':
        return 'Chuva leve';
      default:
        return description; // Caso a descrição não tenha tradução, retorna o original
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Climasync",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlueAccent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
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
            ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Procure por uma localização',
          prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
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
      ),
    );
  }

  Widget _buildCurrentWeather() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _weather?.cityName ?? '',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '${_weather?.temperature.toStringAsFixed(1) ?? ''}°C',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w300,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translateWeatherDescription(_weather?.description ?? ''),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNextHoursForecast() {
    return Container(
      height: 120,
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
    // Converte a string 'time' para DateTime e formata para exibir apenas as horas (ex: 14:00)
    String formattedTime = DateFormat('HH:mm').format(forecast.dateTime);

    return Container(
      width: 90,
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              formattedTime,
              style: TextStyle(fontSize: 16, color: Colors.blueAccent),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 5),
          Icon(
            Icons.wb_sunny,
            size: 30,
            color: Colors.orangeAccent,
          ),
          SizedBox(height: 5),
          Expanded(
            child: Text(
              "${forecast.temperature.toStringAsFixed(1)}°C",
              style: TextStyle(fontSize: 16, color: Colors.blueAccent),
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
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: _dailyForecast != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Próximos 7 dias",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
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
    // Formata a data para exibir o dia da semana (ex: Segunda)
    String formattedDay = DateFormat.EEEE('pt_BR').format(forecast.date);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              formattedDay,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueAccent,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Icon(
                  Icons.wb_sunny,
                  size: 30,
                  color: Colors.orangeAccent,
                ), // Ícone placeholder, substituir por ícone dinâmico
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "${forecast.temperature.toStringAsFixed(1)}°C",
              style: TextStyle(
                fontSize: 16,
                color: Colors.blueAccent,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayDetails() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Detalhes de hoje",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailItem("Humidade", "${_weather?.humidity ?? ''}%"),
              _buildDetailItem("Vento", "${_weather?.windSpeed ?? ''} km/h"),
              _buildDetailItem(
                  "Sensação Térmica", "${_weather?.feelsLike ?? ''}°C"),
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
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueAccent,
          ),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
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

  WeatherInfo _getWeatherInfo(String description) {
    switch (description.toLowerCase()) {
      case 'clear sky':
        return WeatherInfo('Céu limpo', 'assets/icon/clear_sky.png');
      case 'few clouds':
        return WeatherInfo('Algumas nuvens', 'assets/icon/default.png');
      case 'scattered clouds':
        return WeatherInfo('Nuvens dispersas', 'assets/icon/scattered_clouds.png');
      case 'broken clouds':
        return WeatherInfo('Nuvens quebradas', 'assets/icon/broken_clouds.png');
      case 'shower rain':
      case 'moderate rain':
        return WeatherInfo('Garoa', 'assets/icon/shower_rain.png');
      case 'rain':
        return WeatherInfo('Chuva', 'assets/icon/rain.png');
      case 'thunderstorm':
        return WeatherInfo('Trovoada', 'assets/icon/thunderstorm.png');
      case 'snow':
        return WeatherInfo('Neve', 'assets/icon/snow.png');
      case 'mist':
        return WeatherInfo('Névoa', 'assets/icon/mist.png');
      case 'light rain':
        return WeatherInfo('Chuva leve', 'assets/icon/light_rain.png');
      default:
        return WeatherInfo(description, 'assets/icon/default.png');
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
    WeatherInfo? weatherInfo = _weather != null ? _getWeatherInfo(_weather!.description) : null;

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
          Row(
            children: [
              Text(
                _weather?.cityName ?? '',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
             SizedBox(width: 10),
              if (weatherInfo != null)
                Padding(
                  padding: EdgeInsets.only(left: 10), // Adicione o valor de padding que você deseja
                  child: Text(
                    weatherInfo.translation,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                '${_weather?.temperature.toStringAsFixed(1) ?? ''}°C',
                style: TextStyle(
                  fontSize: 85,
                  fontWeight: FontWeight.w300,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(width: 10),
              if (weatherInfo != null)
                Image.asset(
                  weatherInfo.iconPath,
                  width: 60,
                  height: 60,
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
  String formattedTime = DateFormat('HH:mm').format(forecast.dateTime);
  String iconPath = forecast.getTemperatureIcon();

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
          blurRadius: 6,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          formattedTime,
          style: TextStyle(
            fontSize: 18,
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        Flexible( // Use Flexible para ajustar o widget de ícone
          child: Image.asset(
            iconPath,
            width: 40,
            height: 40,
            fit: BoxFit.contain, // Certifique-se de que o ícone se ajuste ao espaço
          ),
        ),
        SizedBox(height: 10),
        Text(
          '${forecast.temperature.toStringAsFixed(1)}°C',
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}


  Widget _buildNextDaysForecast() {
    return _dailyForecast != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _dailyForecast!.map((forecast) {
              return _buildDailyForecastItem(forecast);
            }).toList(),
          )
        : Center(child: Text("Sem dados de previsão diária"));
  }

  Widget _buildDailyForecastItem(DailyForecast forecast) {
    String dayOfWeek = DateFormat('EEEE', 'pt_BR').format(forecast.dateTime);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.4), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dayOfWeek,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          Row(
            children: [
              Icon(
                Icons.wb_cloudy,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 10),
              Text(
                '${forecast.temperatureMax.toStringAsFixed(1)}°C / ${forecast.temperatureMin.toStringAsFixed(1)}°C',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTodayDetails() {
    return _weather != null
        ? Container(
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
                  "Detalhes de hoje",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                SizedBox(height: 10),
                _buildDetailRow("Umidade", '${_weather!.humidity}%'),
                SizedBox(height: 10),
                _buildDetailRow("Vento", '${_weather!.windSpeed} km/h'),
                SizedBox(height: 10),
                _buildDetailRow("Sensação Térmica", '${_weather!.feelsLike.toStringAsFixed(1)}°C'),
              ],
            ),
          )
        : Container();
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: Colors.blueAccent,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }
}

class WeatherInfo {
  final String translation;
  final String iconPath;

  WeatherInfo(this.translation, this.iconPath);
}

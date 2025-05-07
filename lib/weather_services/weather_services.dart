import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final int uvIndex;

  WeatherData({
    required this.uvIndex,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      uvIndex: json['current']['uvi'],
    );
  }
}

class WeatherService {
  static final WeatherService _instance = WeatherService._internal();
  WeatherData? _cachedWeatherData;

  factory WeatherService() {
    return _instance;
  }

  WeatherService._internal();

  final String apiKey = '432a8658a6991c2c948f1125de99c13d';
  final String baseUrl = 'https://api.openweathermap.org/data/3.0/onecall';

  Future<WeatherData> fetchWeatherData(double lat, double lon) async {
    if (_cachedWeatherData != null) {
      return _cachedWeatherData!;
    }

    final response = await http.get(
      Uri.parse('$baseUrl?lat=$lat&lon=$lon&units=metric&appid=$apiKey'),
    );

    print(response.body);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      _cachedWeatherData = WeatherData.fromJson(json);
      return _cachedWeatherData!;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

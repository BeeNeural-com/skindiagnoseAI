import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeatherData {
  final double uvIndex;

  WeatherData({
    required this.uvIndex,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      uvIndex: (json['current']['uvi'] as num).toDouble(),
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

  final String apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? "";
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

import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/weather.dart';
import 'package:http/http.dart' as http;

class WeatherProvider extends ChangeNotifier {
  final String apiKey = '2ba9fe85b28f5ffeee68193e28c6eed6';
  Weather? weather;

  Future<void> fetchWeather(double lat, double lon) async {
    final apiUrl = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey');

    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final weatherData = json.decode(response.body);
      weather = Weather.fromJson(weatherData);
      notifyListeners();
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  String getWeatherIcon() {
    if (weather == null) {
      return '🌤';
    } else {
      switch (weather!.weatherDescription) {
        case 'clear sky':
          return '☀️';
        case 'few clouds':
          return '🌤';
        case 'scattered clouds':
          return '⛅️';
        case 'broken clouds':
          return '☁️';
        case 'shower rain':
          return '🌧';
        case 'rain':
          return '🌧';
        case 'thunderstorm':
          return '⛈';
        case 'snow':
          return '🌨';
        case 'mist':
          return '🌫';
        default:
          return '☀️';
      }
    }
  }

  String getWeatherDescription() {
    if (weather == null) {
      return 'Loading...';
    } else {
      return weather!.weatherDescription;
    }
  }

  String getTemperature() {
    if (weather == null) {
      return 'Loading...';
    } else {
      return '${(weather!.temperature - 273.15).toStringAsFixed(1)}°C';
    }
  }

  String getWindSpeed() {
    if (weather == null) {
      return 'Loading...';
    } else {
      return '${weather!.windSpeed.toStringAsFixed(1)} m/s';
    }
  }

  String getLocationName() {
    if (weather == null) {
      return 'Loading...';
    } else {
      return weather!.locationName;
    }
  }

  void reset() {
    weather = null;
    notifyListeners();
  }
}

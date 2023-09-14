import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import '../models/weather.dart';
import 'package:http/http.dart' as http;

class WeatherProvider extends ChangeNotifier {
  final String apiKey = '2ba9fe85b28f5ffeee68193e28c6eed6';
  Weather? weather;

  Future<void> fetchWeather(double lat, double lon) async {
    final apiUrl = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey');

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
      return 'Loading';
    } else {
      return weather!.weatherDescription;
    }
  }

  String getTemperature() {
    if (weather == null) {
      return 'Loading';
    } else {
      return '${(weather!.temperature - 273.15).toStringAsFixed(1)}°C';
    }
  }

  String getWindSpeed() {
    if (weather == null) {
      return 'Loading';
    } else {
      double windSpeedMetersPerSecond = weather!.windSpeed;
      double windSpeedKilometersPerHour = windSpeedMetersPerSecond * 3.6;
      return '${windSpeedKilometersPerHour.toStringAsFixed(1)} km/h';
    }
  }

  IconData getWindDirectionIcon() {
    // Valid direction angles and their corresponding icons.
    final directions = [
      {'angle': 0, 'icon': WeatherIcons.direction_up},
      {'angle': 45, 'icon': WeatherIcons.direction_up_right},
      {'angle': 90, 'icon': WeatherIcons.direction_right},
      {'angle': 135, 'icon': WeatherIcons.direction_down_right},
      {'angle': 180, 'icon': WeatherIcons.direction_down},
      {'angle': 225, 'icon': WeatherIcons.direction_down_left},
      {'angle': 270, 'icon': WeatherIcons.direction_left},
      {'angle': 315, 'icon': WeatherIcons.direction_up_left},
    ];

    // Calculating the closest direction angle to the given direction.
    double minDifference = double.infinity;
    IconData closestIcon = WeatherIcons.direction_up; // default

    for (final item in directions) {
      final angle = item['angle'] as int;
      final icon = item['icon'] as IconData;
      final difference = (weather?.direction - angle).abs();

      if (difference < minDifference) {
        minDifference = difference;
        closestIcon = icon;
      }
    }

    return closestIcon;
  }

  String getPop() {
    if (weather == null) {
      return 'Loading';
    } else {
      return '${(weather!.pop * 100).toStringAsFixed(1)}%';
    }
  }

  String getLocationName() {
    if (weather == null) {
      return 'Loading';
    } else {
      return weather!.locationName;
    }
  }

  void reset() {
    weather = null;
    notifyListeners();
  }
}

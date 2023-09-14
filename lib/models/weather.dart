class Weather {
  final double temperature;
  final String description;
  final double windSpeed;
  final double windDirection;
  final String locationName;
  final double precipitationProbability;

  get weatherDescription => description;
  get direction => windDirection;
  get pop => precipitationProbability;

  Weather({
    required this.description,
    required this.locationName,
    required this.temperature,
    required this.windSpeed,
    required this.windDirection,
    required this.precipitationProbability,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final firstForecast = json['list'][0];
    return Weather(
      temperature: firstForecast['main']['temp'].toDouble(),
      description: firstForecast['weather'][0]['description'],
      windSpeed: firstForecast['wind']['speed'].toDouble(),
      locationName: json['city']['name'],
      windDirection: firstForecast['wind']['deg'].toDouble(),
      precipitationProbability: firstForecast['pop'].toDouble(),
    );
  }
}

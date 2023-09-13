class Weather {
  final double temperature;
  final String description;
  final double windSpeed;
  final String locationName;

  get weatherDescription => description;

  Weather({required this.temperature, required this.description,
          required this.windSpeed, required this.locationName});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      windSpeed: json['wind']['speed'].toDouble(),
      locationName: json['name'],
    );
  }

}

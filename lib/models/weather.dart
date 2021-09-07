

class Weather {
  final String cityName;
  final double temperature;
  final String iconCode;
  final String description;
  final  String time;
  final bool isFahrenheit;

  Weather(
      {
        this.isFahrenheit = false,
        this.cityName,
        this.temperature,
        this.iconCode,
        this.description,
        this.time});

  Weather copyWith({
    final String cityName,
    final double temperature,
    final String iconCode,
    final String description,
    final  String time,
    final bool isFahrenheit,
  }) {
    return Weather(
      cityName: cityName ?? this.cityName,
      temperature: temperature ?? this.temperature,
      iconCode: iconCode ?? this.iconCode,
      description: description ?? this.description,
      time: time ?? this.time,
      isFahrenheit: isFahrenheit ?? this.isFahrenheit,
    );
  }

  static final empty = Weather(
      cityName: "",
      temperature: 0,
      iconCode: "",
      description: "",
      time: "",
      isFahrenheit: false
  );

  factory Weather.fromStorage(Map<String, dynamic> json) {
    return Weather(
        cityName: json['name'],
        temperature: json['temp'],
        iconCode: json['icon'],
        description: json['description'],
        time: json['dt'].toString(),
        isFahrenheit: json['isFahrenheit']
    );
  }


  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        cityName: json['name'],
        temperature:  double.tryParse(json['main']['temp'].toString()).toDouble(),
        iconCode: json['weather'][0]['icon'],
        description: json['weather'][0]['description'],
        time: json['dt'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
       'name': cityName,
       "temp": temperature,
       "icon": iconCode,
       "description": description,
       "dt": time,
       'isFahrenheit': isFahrenheit
    };

  }
}
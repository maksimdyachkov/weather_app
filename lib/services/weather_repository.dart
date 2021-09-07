

import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_api.dart';

class WeatherRepository {
  WeatherService weatherService = WeatherService();
  Future<Weather> fetchCurrentWeather({ String city, String lat = "", String lon = ""}) {
    return weatherService.fetchCurrentWeather( city: city,lat: lat,lon: lon);
  }
}
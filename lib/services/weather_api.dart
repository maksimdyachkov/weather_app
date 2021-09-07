import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:weather_app/models/weather.dart';

import 'package:http/http.dart' as http;


class WeatherService {
  String _apiKey = "8b1200551cc2a88216763d54a67d3b3f";

  Future<Weather> fetchCurrentWeather(
      {String city, String lat = "", String lon = ""}) async {
    var url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
    final response = await http.post(url);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }

}

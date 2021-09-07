

import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final String title;
  final double temperature;
  final String iconCode;
  final double temperatureFontSize;
  final double iconScale;
  final bool isFahrenheit;

  const WeatherCard({Key key, this.title, this.temperature, this.iconCode, this.temperatureFontSize = 0, this.iconScale = 2, this.isFahrenheit = false}) : super(key: key);

 String getFormattedTemperature(bool isFahrenheit) {
   if(!isFahrenheit) {
     return '${this.temperature.round()} C°';
   } else  {
     return '${this.temperature.round()} F°';
   }

 }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(this.title),
              Image.network("https://openweathermap.org/img/wn/${this.iconCode}@2x.png", scale: this.iconScale),
              Text(
                getFormattedTemperature(isFahrenheit),
                style: TextStyle(fontSize: this.temperatureFontSize, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
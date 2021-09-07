import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/widgets/weather_card.dart';

class SuccessWidget extends StatelessWidget {
  const SuccessWidget({
    Key key,
    @required this.weather,
    @required this.parsedTime,
    @required this.onRefresh,
  }) : super(key: key);

  final Weather weather;
  final DateTime parsedTime;
  final ValueGetter<Future<void>> onRefresh;


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: onRefresh,
            child:  ListView(
              children: [
                SizedBox(height: 30,),
                Column(
                  children: [
                    Text(
                      weather.cityName,
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        '${weather.description}'),
                    SizedBox(height: 20,),
                    WeatherCard(
                      isFahrenheit: weather.isFahrenheit,
                      title: "Last Updated ${TimeOfDay.fromDateTime(parsedTime).format(context)}",
                      temperature: weather.temperature,
                      iconCode: weather.iconCode,
                      temperatureFontSize: 64,
                      iconScale: 1,
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ],
            ),

        )

      ],
    );
  }
}

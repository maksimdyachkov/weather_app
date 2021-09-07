import 'package:flutter/material.dart';
import 'package:weather_app/cubit/weather_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToggleTemperatureWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WeatherCubit cubit = context.watch<WeatherCubit>();
    return Container(
      child: Switch(
          value: cubit.state.weather.isFahrenheit,
          onChanged: (value) {
            cubit.toogleUnits();
          }
      ),
    );
  }
}
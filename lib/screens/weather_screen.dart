import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubit/weather_cubit.dart';
import 'package:weather_app/cubit/weather_state.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/screens/settings_screen.dart';
import 'package:weather_app/widgets/failure_weather.dart';
import 'package:weather_app/widgets/success_weather.dart';
import 'package:pedantic/pedantic.dart';



class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  @override
  Widget build(BuildContext context) {
    return WeatherVIew();
  }

  @override
  void didChangeDependencies() {
    context.read<WeatherCubit>().getCurrentWeatherWithPosition();
    super.didChangeDependencies();
  }
}

class WeatherVIew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar:  _appBar(context),
      body:  BlocBuilder<WeatherCubit,WeatherState>(
        builder: (context,state) {
          if(state.status == WeatherStatus.loading) {
            return Center(child: Platform.isAndroid ? CircularProgressIndicator() : CupertinoActivityIndicator(),);
          }
          else if(state.status == WeatherStatus.success) {
            Weather weather = state.weather;
            DateTime parsedTime = weather.time.isNotEmpty ?  DateTime.fromMillisecondsSinceEpoch(int.tryParse(weather.time) * 1000) : DateTime.now();
            return SuccessWidget(
                weather: weather,
                parsedTime: parsedTime,
                onRefresh: () {
                  return  context.read<WeatherCubit>().fetchCurrentWeather(city: weather.cityName);
                }
            );
          } else if(state.status == WeatherStatus.failure) {
            return FailureWidget();
          }
          else {
            return Container(
              child: SelectCity(),
            );
          }
        },
      ),
    );
  }

 AppBar _appBar(BuildContext context) {
    return AppBar(
      actions: [
        InkWell(
          onTap: () async {
            final String city = await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => SettingsPage()));
            if(city != null && city.isNotEmpty) {
              unawaited(context.read<WeatherCubit>().fetchCurrentWeather(city: city));
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.settings),
          ),
        ),
      ],
      //:
      title: Text("Weather",style: TextStyle(fontSize: 24,color: Colors.black),),
    );
  }
}


class SelectCity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size  = MediaQuery.of(context).size;
    return Center(
     child: InkWell(
       onTap: () async {
         final String city = await Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => SettingsPage()));
         if(city != null && city.isNotEmpty) {
           unawaited(context.read<WeatherCubit>().fetchCurrentWeather(city: city));
         }
       },
         child: Container(width: size.width,height: 100,alignment: Alignment.center, child: Text("Please select a city!",style: TextStyle(fontSize: 24),))),
    );
  }
}


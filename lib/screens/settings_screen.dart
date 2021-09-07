import 'package:flutter/material.dart';
import 'package:weather_app/cubit/weather_cubit.dart';
import 'package:weather_app/cubit/weather_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/widgets/toggle_temperature_widget.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final TextEditingController _textController = TextEditingController();
  String get _text => _textController.text;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings",style: TextStyle(fontSize: 24,color: Colors.black),),),
      body: ListView(
        children: <Widget>[
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      hintText: 'Kyiv',
                    ),
                  ),
                ),
              ),
              IconButton(
                key: const Key('searchPage_search_iconButton'),
                icon: const Icon(Icons.search),
                onPressed: () => Navigator.of(context).pop(_text),
              )
            ],
          ),
          SizedBox(height: 10,),
          BlocBuilder<WeatherCubit, WeatherState>(
            buildWhen: (previous, current) =>
            previous.weather.isFahrenheit != current.weather.isFahrenheit,
            builder: (context, state) {
              return ListTile(
                title: const Text('Temperature Units'),
                isThreeLine: true,
                subtitle: const Text(
                  'Use imperial measurements for temperature units.',
                ),
                trailing: ToggleTemperatureWidget(),
              );
            },
          ),
        ],
      ),
    );
  }
}

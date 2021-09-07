import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/services/weather_repository.dart';

import 'cubit/weather_cubit.dart';
import 'screens/weather_screen.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main()  async{
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getTemporaryDirectory(),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
 final WeatherRepository _weatherRepository = WeatherRepository();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherCubit(_weatherRepository),
      child: MaterialApp(
        title: 'Flutter Weather',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: WeatherScreen(),
        ),
      ),
    );
  }
}





import 'package:weather_app/cubit/weather_state.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:geolocator/geolocator.dart';

class WeatherCubit extends HydratedCubit<WeatherState> {
  final WeatherRepository _weatherRepository;


  WeatherCubit(this._weatherRepository) : super(WeatherState());
  bool toggleTemperature = false;

  Future<Weather> fetchCurrentWeather(
      { String city = "", String lat = "", String lon = ""}) async {
    try{
      emit(state.copyWith(status: WeatherStatus.loading));
      Weather weatherResp = await _weatherRepository.fetchCurrentWeather(city: city, lat: lat, lon: lon);
      double FT =  ((weatherResp.temperature * 9 / 5) + 32);
        emit(state.copyWith(status: WeatherStatus.success,
                weather: weatherResp.copyWith(
                    isFahrenheit: state.weather.isFahrenheit,
                    temperature:  state.weather.isFahrenheit ? FT : weatherResp.temperature, time: weatherResp.time,
                    description: weatherResp.description,
        )));
      return weatherResp;
    } catch (_) {
      emit(state.copyWith(weather: Weather.empty, status: WeatherStatus.failure));
      return Weather.empty;
    }
  }
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;



    // сall position determination only if weather data has not been received yet
    if(state.weather != Weather.empty) {
      return Future.error('There is already data in the store');
    }


    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentWeatherWithPosition() async{
    var location = await determinePosition();
    if(location == null) return;
    fetchCurrentWeather(lon: location.longitude.toString(),lat: location.latitude.toString(),city: "");
  }

  void toogleUnits() {
    final weather = state.weather;
    toggleTemperature = weather.isFahrenheit;
    toggleTemperature =!toggleTemperature;
    emit(state.copyWith(
        weather: weather.copyWith(isFahrenheit: toggleTemperature,temperature: toggleTemperature ? toFahrenheit() : toCelsius())));
  }

  double toFahrenheit() {
    return ((state.weather.temperature * 9 / 5) + 32);
  }
  double toCelsius() {
    return ((state.weather.temperature - 32) * 5 / 9);
  }

  @override
  WeatherState fromJson(Map<String, dynamic> json) {
    try{
      return WeatherState.fromMap(json);
    }catch(_) {
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(WeatherState state) {
    try{
      return state.toMap(state);
    }
    catch(_) {
      return null;
    }
  }
}


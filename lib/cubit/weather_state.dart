

import 'dart:convert';

import 'package:weather_app/models/weather.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

enum WeatherStatus { initial, loading, success, failure }

extension WeatherStatusX on WeatherStatus {
  bool get isInitial => this == WeatherStatus.initial;
  bool get isLoading => this == WeatherStatus.loading;
  bool get isSuccess => this == WeatherStatus.success;
  bool get isFailure => this == WeatherStatus.failure;
}

const _$WeatherStatusEnumMap = {
  WeatherStatus.initial: 'initial',
  WeatherStatus.loading: 'loading',
  WeatherStatus.success: 'success',
  WeatherStatus.failure: 'failure',
};

K _$enumDecode<K, V>(
    Map<K, V> enumValues,
    Object source, {
      K unknownValue,
    }) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
          '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
        (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

  class WeatherState extends Equatable{
    final WeatherStatus status;
      Weather weather;
    WeatherState({
      this.status =  WeatherStatus.initial,
      Weather weather,
    }) : weather = weather ?? Weather.empty;

      WeatherState copyWith({
      WeatherStatus status,
      Weather weather,
    }) {
      return WeatherState(
        status: status ?? this.status,
        weather: weather ?? this.weather,
      );
    }

    String getFormattedDateTime(String date) {
      DateTime parsedTime = DateTime.fromMillisecondsSinceEpoch(int.tryParse(date) * 1000);
      String formattedTime = DateFormat.Hm().format(parsedTime);
      return formattedTime;
    }

    Map<String, dynamic> toMap(WeatherState instance) {
      return {
        'status': _$WeatherStatusEnumMap[instance.status],
        'weather': weather.toJson() ?? weather ,
      };
    }

    factory WeatherState.fromMap(Map<String, dynamic> map) {
      return WeatherState(
        status:  _$enumDecode(_$WeatherStatusEnumMap,map['status']),
        weather: Weather.fromStorage(map['weather']),
      );
    }

    String toJson(WeatherState instance) => json.encode(toMap(instance));

    factory WeatherState.fromJson(String source) =>
        WeatherState.fromMap(json.decode(source));

    @override
  List<Object> get props => [status,weather];
}

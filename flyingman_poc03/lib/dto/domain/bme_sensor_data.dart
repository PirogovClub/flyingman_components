

import 'package:flyingman_poc03/utils/uid.dart';

const sensorIdJsonNameFromSensor = "Name";
const pressureJsonNameFromSensor = "T";
const temperatureJsonNameFromSensor = "P";
const humidityJsonNameFromSensor = "Hm";
const measurementIdJsonNameFromSensor = "Name";
const altitudeJsonNameFromSensor = "AltitudeM";

const sensorIdJsonNameToBackEnd = "sensorId";
const pressureJsonNameToBackEnd = "temperature";
const temperatureJsonNameToBackEnd = "pressure";
const humidityJsonNameToBackEnd = "humidity";
const measurementIdJsonNameToBackEnd = "measurementId";
const altitudeJsonNameToBackEnd = "altitude";

class BmeSensorsData {
  final String sensorID;
  final double pressure;
  final double temperature;
  final double humidity;
  final String measurementId;
  final double altitude;

  const BmeSensorsData(
      {required this.sensorID,
      required this.pressure,
      required this.temperature,
      required this.humidity,
      required this.measurementId,
      required this.altitude});

  factory BmeSensorsData.fromJson(Map<String, dynamic> json) {
    return BmeSensorsData(
      sensorID: Uid().getSensorID(json[sensorIdJsonNameFromSensor] as String),
      pressure: json[pressureJsonNameFromSensor] as double,
      temperature: json[temperatureJsonNameFromSensor] as double,
      humidity: json[humidityJsonNameFromSensor] as double,
      measurementId: Uid().getSensorID(json[sensorIdJsonNameFromSensor] as String),
      altitude: json[altitudeJsonNameFromSensor] as double,
    );
  }

  Map<String, dynamic> toJsonFromSensor() => {
        sensorIdJsonNameFromSensor: sensorID,
        pressureJsonNameFromSensor: pressure,
        temperatureJsonNameFromSensor: temperature,
        humidityJsonNameFromSensor: humidity,
        measurementIdJsonNameFromSensor: measurementId,
        altitudeJsonNameFromSensor: altitude,
      };

  Map<String, dynamic> toJsonToBackEnd() => {
        sensorIdJsonNameFromSensor: sensorID,
        pressureJsonNameFromSensor: pressure,
        temperatureJsonNameFromSensor: temperature,
        humidityJsonNameFromSensor: humidity,
        measurementIdJsonNameFromSensor: measurementId,
        altitudeJsonNameFromSensor: altitude,
      };
}

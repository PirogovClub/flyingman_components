import 'package:flyingman_poc03/dto/domain/mesurments.dart';
import 'package:flyingman_poc03/dto/domain/sensor_data.dart';
import 'package:flyingman_poc03/dto/domain/users.dart';
import 'package:flyingman_poc03/utils/uid.dart';

import '../../constants.dart';

const sensorIdJsonNameFromSensor = "Name";
const pressureJsonNameFromSensor = "T";
const temperatureJsonNameFromSensor = "P";
const humidityJsonNameFromSensor = "Hm";
const measurementIdJsonNameFromSensor = "Name";
const altitudeJsonNameFromSensor = "AltitudeM";

const sensorNameJsonNameFromSensor = "Name";
const altitudeFJsonNameFromSensor = "AltitudeF";

const sensorIdJsonNameToBackEnd = "sensorId";
const pressureJsonNameToBackEnd = "temperature";
const temperatureJsonNameToBackEnd = "pressure";
const humidityJsonNameToBackEnd = "humidity";
const measurementIdJsonNameToBackEnd = "measurementId";
const altitudeJsonNameToBackEnd = "altitude";
const sensorNameJsonNameToBackEnd = "sensor_name";
const altitudeFJsonNameToBackEnd = "altitude_f";

class BmeSensorsData implements SensorData {
  final String sensorID;
  double pressure;
  double temperature;
  double altitude;
  String sensorName;
  double altitude_f;
  double humidity;
  final Measurements measurement;
  DateTime time;
  String location;

  BmeSensorsData(
      {required this.sensorID,
      required this.pressure,
      required this.temperature,
      required this.altitude,
      required this.sensorName,
      required this.altitude_f,
      required this.humidity,
      required this.measurement,
      required this.time,
      required this.location});

  factory BmeSensorsData.fromJson(Map<String, dynamic> json) {
    return BmeSensorsData(
        sensorID: Uid().getSensorID(json[sensorIdJsonNameFromSensor].toString()),
        pressure: json[pressureJsonNameFromSensor] as double,
        temperature: json[temperatureJsonNameFromSensor] as double,
        altitude: json[altitudeJsonNameFromSensor] as double,
        sensorName: json[sensorNameJsonNameFromSensor] as String,
        altitude_f: json[altitudeFJsonNameFromSensor] as double,
        humidity: json[humidityJsonNameFromSensor] as double,
        measurement: Measurements(
          user_id: new UserData(id: userID),
          user_device_id: "",
          measurement_uuid: Uid().getSensorID(
              "Phone" + DateTime.now().millisecondsSinceEpoch.toString()),
        ),
        time: DateTime.now(),
        location: "");
  }


  Map<String, dynamic> toJsonFromSensor() => {
        sensorIdJsonNameFromSensor: sensorID,
        pressureJsonNameFromSensor: pressure,
        temperatureJsonNameFromSensor: temperature,
        humidityJsonNameFromSensor: humidity,
        measurementIdJsonNameFromSensor: measurement,
        altitudeJsonNameFromSensor: altitude,
      };

  Map<String, dynamic> toJsonToBackEnd() => {
        sensorIdJsonNameToBackEnd: sensorID,
        pressureJsonNameToBackEnd: pressure,
        temperatureJsonNameToBackEnd: temperature,
        altitudeJsonNameToBackEnd: altitude,
        sensorNameJsonNameToBackEnd: sensorName,
        altitudeFJsonNameToBackEnd: altitude_f,
        humidityJsonNameToBackEnd: humidity,
        "time": time,
        "measurement_id": measurement.toJsonToBackEnd(),
        "location": location,
      };
}



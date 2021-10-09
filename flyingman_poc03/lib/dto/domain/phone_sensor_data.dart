import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

import 'mesurments.dart';

class PhoneSensorData {
  /*var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
  var inputDate = inputFormat.parse('31/12/2000 23:59'); // <-- dd/MM 24H format

  var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
  var outputDate = outputFormat.format(inputDate);

  print(outputDate); // 12/31/2000 11:59 PM <-- MM/dd 12H format*/

  final String sensorId;
  final Decimal gyroscope_x;
  final Decimal gyroscope_y;
  final Decimal gyroscope_z;
  final Decimal magnitometr_x;
  final Decimal magnitometr_y;
  final Decimal magnitometr_z;
  final Decimal accelerometer_x;
  final Decimal accelerometer_y;
  final Decimal accelerometer_z;
  final Decimal user_accelerometer_x;
  final Decimal user_accelerometer_y;
  final Decimal user_accelerometer_z;
  final Decimal altitude;
  final Decimal latitude;
  final Decimal longitude;
  final Decimal heading;
  final Decimal accuracy;
  final DateTime time;
  final DateTime local_time;
  final Measurements measurement_id;

  const PhoneSensorData(
      {required this.sensorId,
      required this.gyroscope_x,
      required this.gyroscope_y,
      required this.gyroscope_z,
      required this.magnitometr_x,
      required this.magnitometr_y,
      required this.magnitometr_z,
      required this.accelerometer_x,
      required this.accelerometer_y,
      required this.accelerometer_z,
      required this.user_accelerometer_x,
      required this.user_accelerometer_y,
      required this.user_accelerometer_z,
      required this.altitude,
      required this.latitude,
      required this.longitude,
      required this.heading,
      required this.accuracy,
      required this.time,
      required this.local_time,
      required this.measurement_id});

  Map<String, dynamic> toJsonToBackEnd() => {
        "sensorId": sensorId,
        "gyroscope_x": gyroscope_x,
        "gyroscope_y": gyroscope_y,
        "gyroscope_z": gyroscope_z,
        "magnitometr_x": magnitometr_x,
        "magnitometr_y": magnitometr_y,
        "magnitometr_z": magnitometr_z,
        "accelerometer_x": accelerometer_x,
        "accelerometer_y": accelerometer_y,
        "accelerometer_z": accelerometer_z,
        "user_accelerometer_x": user_accelerometer_x,
        "user_accelerometer_y": user_accelerometer_y,
        "user_accelerometer_z": user_accelerometer_z,
        "altitude": altitude,
        "latitude": latitude,
        "longitude": longitude,
        "heading": heading,
        "accuracy": accuracy,
        "time": time,
        "local_time": local_time,
        "measurement_id": measurement_id.toJsonToBackEnd()
      };

  factory PhoneSensorData.fromJson(Map<String, dynamic> json) {
    return PhoneSensorData(
        sensorId: json["sensorId"],
        gyroscope_x: Decimal.parse(json["gyroscope_x"]),
        gyroscope_y: Decimal.parse(json["gyroscope_y"]),
        gyroscope_z: Decimal.parse(json["gyroscope_z"]),
        magnitometr_x: Decimal.parse(json["magnitometr_x"]),
        magnitometr_y: Decimal.parse(json["magnitometr_y"]),
        magnitometr_z: Decimal.parse(json["magnitometr_z"]),
        accelerometer_x: Decimal.parse(json["accelerometer_x"]),
        accelerometer_y: Decimal.parse(json["accelerometer_y"]),
        accelerometer_z: Decimal.parse(json["accelerometer_z"]),
        user_accelerometer_x: Decimal.parse(json["user_accelerometer_x"]),
        user_accelerometer_y:Decimal.parse( json["user_accelerometer_y"]),
        user_accelerometer_z:Decimal.parse( json["user_accelerometer_z"]),
        altitude:Decimal.parse( json["altitude"]),
        latitude:Decimal.parse( json["latitude"]),
        longitude:Decimal.parse( json["longitude"]),
        heading: Decimal.parse(json["heading"]),
        accuracy:Decimal.parse( json["accuracy"]),
        time: json["time"],
        local_time: json["local_time"],
        measurement_id: Measurements.fromJson(json["measurement_id"]));
  }
}

import 'package:decimal/decimal.dart';
import 'package:flyingman_poc03/dto/domain/sensor_data.dart';
import 'package:intl/intl.dart';
import 'mesurments.dart';

class PhoneSensorData implements SensorData {
  /*var inputFormat = DateFormat('dd/MM/yyyy HH:mm');
  var inputDate = inputFormat.parse('31/12/2000 23:59'); // <-- dd/MM 24H format

  var outputFormat = DateFormat('MM/dd/yyyy hh:mm a');
  var outputDate = outputFormat.format(inputDate);

  print(outputDate); // 12/31/2000 11:59 PM <-- MM/dd 12H format*/

  final String sensorId;
  double gyroscope_x;
  double gyroscope_y;
  double gyroscope_z;
  double magnitometr_x;
  double magnitometr_y;
  double magnitometr_z;
  double accelerometer_x;
  double accelerometer_y;
  double accelerometer_z;
  double user_accelerometer_x;
  double user_accelerometer_y;
  double user_accelerometer_z;
  double altitude;
  double latitude;
  double longitude;
  double heading;
  double accuracy;
  DateTime time;
  DateTime local_time;
  final Measurements measurement_id;

  PhoneSensorData(
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
        gyroscope_x: (json["gyroscope_x"]),
        gyroscope_y: json["gyroscope_y"],
        gyroscope_z: json["gyroscope_z"],
        magnitometr_x: json["magnitometr_x"],
        magnitometr_y: json["magnitometr_y"],
        magnitometr_z: json["magnitometr_z"],
        accelerometer_x: json["accelerometer_x"],
        accelerometer_y: json["accelerometer_y"],
        accelerometer_z: json["accelerometer_z"],
        user_accelerometer_x: json["user_accelerometer_x"],
        user_accelerometer_y: json["user_accelerometer_y"],
        user_accelerometer_z: json["user_accelerometer_z"],
        altitude: json["altitude"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        heading: json["heading"],
        accuracy: json["accuracy"],
        time: DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').parse(json["time"]),
        local_time:
            DateFormat('yyyy-MM-ddTHH:mm:ss.SSSZ').parse(json["local_time"]),
        measurement_id: Measurements.fromJson(json["measurement_id"]));
  }
}

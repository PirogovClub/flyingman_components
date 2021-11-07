import 'package:flyingman_poc03/dto/domain/mesurments.dart';
import 'package:flyingman_poc03/dto/domain/phone_sensor_data.dart';
import 'package:flyingman_poc03/dto/domain/users.dart';
import 'package:flyingman_poc03/utils/uid.dart';

import '../../constants.dart';

class PhoneSensorsContainer {
  static PhoneSensorData _phoneSensorData = PhoneSensorData(
    sensorId: "2c497cf7-7697-4a5c-8cb7-bc1657d88883",
    gyroscope_x: 0,
    gyroscope_y: 0,
    gyroscope_z: 0,
    magnitometr_x: 0,
    magnitometr_y: 0,
    magnitometr_z: 0,
    accelerometer_x: 0,
    accelerometer_y: 0,
    accelerometer_z: 0,
    user_accelerometer_x: 0,
    user_accelerometer_y: 0,
    user_accelerometer_z: 0,
    altitude: 0,
    latitude: 0,
    longitude: 0,
    heading: 0,
    accuracy: 0,
    time: new DateTime.now(),
    local_time: new DateTime.now(),
    measurement_id: Measurements(
      user_id: new UserData(id: userID),
      user_device_id: "",
      measurement_uuid: Uid().getSensorID(
          "Phone" + DateTime.now().millisecondsSinceEpoch.toString()),
    ),
  );

  PhoneSensorData get phoneSensorData => _phoneSensorData;

  set phoneSensorData(PhoneSensorData value) {
    _phoneSensorData = value;
  }
}

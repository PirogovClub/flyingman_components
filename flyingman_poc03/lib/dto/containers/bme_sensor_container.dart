
import 'package:flyingman_poc03/dto/domain/bme_sensor_data.dart';
import 'package:flyingman_poc03/dto/domain/mesurments.dart';
import 'package:flyingman_poc03/dto/domain/users.dart';

class BmeSensorsContainer{

  static BmeSensorsData _bmeSensorsData = BmeSensorsData(
      pressure: 0,
      temperature: 0,
      altitude: 0,
      sensorName: "",
      altitude_f: 0,
      humidity: 0,
      measurement: Measurements(
        user_id: new UserData(id: 0),
        user_device_id: "",
        measurement_uuid: "",
      ),
      time: DateTime.now(),
      location: "",
      sensorID: ''
  );

  BmeSensorsData get bmeSensorsData => _bmeSensorsData;

  set bmeSensorData(BmeSensorsData value) {
    _bmeSensorsData = value;
  }


}
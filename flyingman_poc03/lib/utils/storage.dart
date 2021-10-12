import 'dart:async';

import 'dart:convert';

import 'dart:io' as io;

import 'package:flutter/services.dart';
import 'package:flyingman_poc03/dto/containers/phone_sensor_container.dart';
import 'package:flyingman_poc03/dto/domain/phone_sensor_data.dart';
import 'package:flyingman_poc03/dto/domain/users.dart';
import 'package:flyingman_poc03/utils/uid.dart';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:sensors_plus/sensors_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:location/location.dart';

import 'local_system_time_util.dart';

enum StorageType { internal, external }

class CounterStorage {
  //choose where to store file
  //TODO:make this place more secure
  StorageType storageType = StorageType.external;
  final Location location = Location();
  final LocalSystemTimeUtil _localSystemTimeUtil = new LocalSystemTimeUtil();

  String? _error;



  static StreamSubscription<LocationData>? _locationSubscription;

  static String _locationData = "";

  set locationData(String value) {
    _locationData = value;
  }

  CounterStorage() {

  }

  String get locationData => _locationData;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<String> get _externalPath async {
    final directory = await getExternalStorageDirectory();

    return directory!.path;
  }

  Future<io.File> get _localFile async {
    final path = await _localPath;
    return io.File('$path/counter.txt');
  }

  Future<io.File> get _externalFile async {
    final path = await _externalPath;
    return io.File('$path/counter.txt');
  }

  Future<io.File> getFile(StorageType storageType) async {
    Future<io.File> toReturn;
    switch (storageType) {
      case StorageType.external:
        toReturn = _externalFile;
        break;
      case StorageType.internal:
        toReturn = _localFile;
        break;
    }
    return await toReturn;
  }

  Future<String> readCounter() async {
    try {
      final file = await getFile(storageType);

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "Error Reading file";
    }
  }

  Future<io.File> writeCounter(int counter) async {
    final file = await getFile(storageType);

    // Write the file
    return file.writeAsString('$counter', mode: io.FileMode.append);
  }

  Future<io.File> storeData(String string) async {
    final file = await getFile(storageType);
    string = string + "\n";
    // Write the file
    return file.writeAsString(string, mode: io.FileMode.append);
  }

  Future<io.File> writeStringToFile(String string) async {
    final file = await getFile(storageType);
    string = string + "\n";
    // Write the file
    return file.writeAsString(string, mode: io.FileMode.append);
  }

  Future<http.Response> saveToDB(String objectTSend, String sensorType) async {
    String uuid = Uid().getSensorID("Phone");
    String incomingJson = objectTSend;
    String jsonStringSample =
        """{\"sensorId\": \"2c497cf7-7697-4a5c-8cb7-bc1657d88883\",
            \"gyroscope_x\": 22.35,
    \"gyroscope_y\": 22.35,
    \"gyroscope_z\": 22.35,
    \"magnitometr_x\": 22.35,
    \"magnitometr_y\": 22.35,
    \"magnitometr_z\": 22.35,
    \"accelerometer_x\": 22.35,
    \"accelerometer_y\": 22.35,
    \"accelerometer_z\": 22.35,
    \"user_accelerometer_x\": 22.35,
    \"user_accelerometer_y\": 22.35,
    \"user_accelerometer_z\": 22.35,
    \"altitude\": 22.35,
    \"latitude\": 22.35,
    \"longitude\": 22.35,
    \"heading\": 22.35,
    \"accuracy\": 22.35,
    \"measurement_id\": {
    \"measurement_uuid\": \"""" +
            uuid +
            """\",
    \"user_device_id\":1,
    \"user_id\": {
    \"nick_name\":\"Hello\",
    \"id\": 6,
    \"first_name\":\"FLuY\"
    
  }
    },
  \"time\": \"2021-10-03T09:09:00.403-08:00\",
  \"local_time\": \"2021-10-03T09:09:00.403-08:00\"
 }""";

    print(jsonStringSample);
    print(incomingJson);
    Map<String, dynamic> json = jsonDecode(jsonStringSample);
    //PhoneSensorData phoneSensorData = PhoneSensorData.fromJson(json);
    PhoneSensorData phoneSensorData = SensorsContainer().phoneSensorData;

    phoneSensorData.measurement_id.measurement_uuid = uuid;
    phoneSensorData.measurement_id.user_device_id = 1;
    phoneSensorData.measurement_id.user_id = new UserData(id: 6);

    print(jsonEncode(phoneSensorData.toJsonToBackEnd(), toEncodable: myEncode)
        .toString());
    return (http.post(Uri.parse('http://69.87.221.132:8080/phonedata/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(phoneSensorData.toJsonToBackEnd(),
            toEncodable: myEncode)));
  }

  dynamic myEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }
}

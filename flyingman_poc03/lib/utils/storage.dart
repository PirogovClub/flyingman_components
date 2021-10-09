import 'dart:convert';
import 'dart:io';

import 'package:flyingman_poc03/dto/domain/phone_sensor_data.dart';
import 'package:flyingman_poc03/utils/uid.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

enum StorageType { internal, external }

class CounterStorage {
  //choose where to store file
  //TODO:make this place more secure
  StorageType storageType = StorageType.external;

  static String _locationData = "";

  set locationData(String value) {
    _locationData = value;
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

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<File> get _externalFile async {
    final path = await _externalPath;
    return File('$path/counter.txt');
  }

  Future<File> getFile(StorageType storageType) async {
    Future<File> toReturn;
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

  Future<File> writeCounter(int counter) async {
    final file = await getFile(storageType);

    // Write the file
    return file.writeAsString('$counter', mode: FileMode.append);
  }

  Future<File> storeData(String string) async {
    final file = await getFile(storageType);
    string = string + "\n";
    // Write the file
    return file.writeAsString(string, mode: FileMode.append);
  }

  Future<File> writeStringToFile(String string) async {
    final file = await getFile(storageType);
    string = string + "\n";
    // Write the file
    return file.writeAsString(string, mode: FileMode.append);
  }

  Future<Response> saveToDB(Object objectTSend, String sensorType) async {
    String uuid = Uid().getSensorID("Phone");
    String jsonStringSample = """{\"sensorId\": \"2c497cf7-7697-4a5c-8cb7-bc1657d88883\",
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
    \"measurement_uuid\": \"""" +  uuid + """\",
    \"user_id\": {
    \"nick_name\":\"Hello\",
    \"id\": 6,
    \"first_name\":\"FLuY\"

  }
    },
  \"time\": \"2021-10-03T09:09:00.403-08:00\",
  \"local_time\": \"2021-10-03T09:09:00.403-08:00\"
 }""";
    Map<String,dynamic> json = jsonDecode(jsonStringSample);
    PhoneSensorData phoneSensorData = PhoneSensorData.fromJson(json);
    print(phoneSensorData);
    return (http.post(Uri.parse('http://69.87.221.132:8080/phonedata/add'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonStringSample));
  }
}

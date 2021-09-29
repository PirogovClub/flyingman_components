import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

enum StorageType {
  internal,
  external
}

class CounterStorage {

  //choose where to store file
  //TODO:make this place more secure
  StorageType storageType = StorageType.external;

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


  Future<File>  getFile(StorageType storageType) async {
    Future<File> toReturn;
    switch (storageType) {
      case StorageType.external:
        toReturn = _externalFile;
        break;
      case StorageType.internal:
        toReturn =  _localFile;
        break;
    }
    return  await toReturn;
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
    string = string +"\n";
    // Write the file
    return file.writeAsString(string, mode: FileMode.append);
  }

  Future<File> writeStringToFile(String string) async {
    final file = await getFile(storageType);
    string = string +"\n";
    // Write the file
    return file.writeAsString(string, mode: FileMode.append);
  }

  Future<String> saveToDB(String title) async {
    return (await http.post(
      Uri.parse('http://69.87.221.132:8080/sensordata/add'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{

          "sensorId": "a2e67216-2964-492a-9e7a-898f29a54430",
          "pressure": "72.5",
          "temperature": "45.8",
          "humidity": "55.66",
          "measurementId": "a2e67216-2964-492a-9e7a-898f29a54430"

      }),
    )).body.toString();
  }

}
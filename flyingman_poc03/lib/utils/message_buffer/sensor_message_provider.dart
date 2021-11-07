import 'dart:collection';

import 'package:flyingman_poc03/utils/message_buffer/sensor_message.dart';
import 'package:sqflite/sqflite.dart';

import 'constants.dart';

class SensorMessageProvider {
  Database? db;

  late Batch batch;
  late List<Object?> results;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableMessages ( 
  $columnId integer primary key autoincrement, 
  $columnMessageBody text not null,
  $columnTimeAdded text not null,
  $columnTimeLastRetry text not null,
  $columnEndPoint text not null,
  $columnMessageType text not null,
  $columnDone integer not null)
''');
    });
    batch = db!.batch();
  }

  init() {}

  void addInsertToBatch(SensorMessage sensorMessage) {
    batch.insert(tableMessages, sensorMessage.toMapForInsert());
  }

  void addDeleteToBatch(SensorMessage sensorMessage) {
    batch.delete(tableMessages, whereArgs: [sensorMessage.id]);
  }

  commitChanges() async {
    /*await db!.transaction((txn) async {
      print("in transaction of commit changes");
      var localbatch = txn.batch();
      localbatch = batch;
      results = await localbatch.commit();
    });*/
    print("batch size");
    Batch tmpBatch = batch;
    batch = db!.batch();
    results = await tmpBatch.commit(continueOnError: true);
    print("batch result length:" + results.toList().length.toString());

  }

  Future<SensorMessage> insert(SensorMessage sensorMessage) async {
    sensorMessage.id = await db!.insert(tableMessages, sensorMessage.toMap());
    return sensorMessage;
  }

  Future<SensorMessage?> getSensorMessage(int id) async {
    List<Map<String, Object?>> maps = await db!.query(tableMessages,
        columns: [columnId, columnDone, columnMessageBody],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return SensorMessage.fromMap(maps.first);
    }
    return null;
  }

  Future<int> getAmountMessageInBuffer() async {
    int intToReturn = 0;

    List<Map<String, Object?>> maps = await db!.query(tableMessages,
        columns: [columnId], where: '$columnId = ?', whereArgs: ["*"]);
    if (maps.isNotEmpty) {
      intToReturn = maps.length;
    }

    return intToReturn;
  }

  Future<List<SensorMessage>> getAllSensorMessages() async {
    List<SensorMessage> listToReturn = [];
//TODO: add dynamic change of limit based on infromation from the server if it is capable to handle more or less
    var results = await db!.query(tableMessages,
        columns: [
          columnId,
          columnDone,
          columnMessageBody,
          columnEndPoint,
          columnTimeAdded,
          columnTimeLastRetry,
          columnMessageType
        ],
        limit: 60);
    if (results.isNotEmpty) {
      for (var sensor in results) {
   //     print("Sensor info:" + sensor.toString());
        listToReturn.add(SensorMessage.fromMap(sensor));
      }
    }
    return listToReturn;
  }

  void delete(int id) {
    batch.delete(tableMessages, where: '$columnId = ?', whereArgs: <int>[id]);
  }

   update(SensorMessage sensorMessage) async {
     batch.update(tableMessages, sensorMessage.toMap(),
        where: '$columnId = ?', whereArgs: [sensorMessage.id]);
  }

  Future close() async => db!.close();
}

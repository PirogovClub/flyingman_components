import 'package:flyingman_poc03/utils/message_buffer/sensor_message.dart';
import 'package:sqflite/sqflite.dart';

import 'constants.dart';

class SensorMessageProvider {
  Database? db;

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

  Future<List<SensorMessage>> getAllSensorMessages() async {
    List<SensorMessage> listToReturn = [];
    List<Map<String, Object?>> maps = await db!.query(tableMessages,
        columns: [
          columnId,
          columnDone,
          columnMessageBody,
          columnEndPoint,
          columnTimeAdded,
          columnTimeLastRetry,
          columnMessageType
        ],
        where: '$columnId = ?',
        whereArgs: ["*"]);
    if (maps.isNotEmpty) {
      for (var sensor in maps) {
        listToReturn.add(SensorMessage.fromMap(sensor));
      }
    }
    return listToReturn;
  }

  Future<int> delete(int id) async {
    return await db!
        .delete(tableMessages, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(SensorMessage sensorMessage) async {
    return await db!.update(tableMessages, sensorMessage.toMap(),
        where: '$columnId = ?', whereArgs: [sensorMessage.id]);
  }

  Future close() async => db!.close();
}

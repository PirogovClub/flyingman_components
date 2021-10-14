import 'package:flyingman_poc03/utils/message_buffer/sensor_message.dart';
import 'package:sqflite/sqflite.dart';

import 'constants.dart';




class SensorMessageProvider {
  late Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableMessages ( 
  $columnId integer primary key autoincrement, 
  $columnMessageBody text not null,
  $columnTimeAdded text not null,
  $columnTimeLastRetry text not null,
  $columnDone integer not null)
''');
    });
  }

  Future<SensorMessage> insert(SensorMessage sensorMessage) async {
    sensorMessage.id = await db.insert(tableMessages, sensorMessage.toMap());
    return sensorMessage;
  }

  Future<SensorMessage?> getSensorMessage(int id) async {
    List<Map<String, Object?>> maps = await db.query(tableMessages,
        columns: [columnId, columnDone, columnMessageBody],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return SensorMessage.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tableMessages, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(SensorMessage sensorMessage) async {
    return await db.update(tableMessages, sensorMessage.toMap(),
        where: '$columnId = ?', whereArgs: [sensorMessage.id]);
  }

  Future close() async => db.close();
}

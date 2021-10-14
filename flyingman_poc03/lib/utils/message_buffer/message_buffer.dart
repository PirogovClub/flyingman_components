import 'dart:async';

import 'package:flyingman_poc03/dto/domain/sensor_data.dart';
import 'package:flyingman_poc03/utils/message_buffer/sensor_message.dart';
import 'package:flyingman_poc03/utils/message_buffer/sensor_message_provider.dart';
import 'package:flyingman_poc03/utils/states_dto.dart';

import 'package:sqflite/sqflite.dart';

import '../storage.dart';

class MessageBuffer  {
  List<SensorMessage> _sensor_messages = [];
  final SensorMessageProvider _sensorMessageProvider = SensorMessageProvider();
  final InfoStorage _infoStorage = InfoStorage();
  
  MessageBuffer(){
    String path = (_infoStorage.getFilePath().toString())+"/messageStorage.db";
    _sensorMessageProvider.open(path);
  }

  Future<void> addMessageToBuffer(SensorMessage sensorMessage) async {
    //To move logic from storage to here
    sensorMessage.timeAdded = DateTime.now();
    sensorMessage = await _sensorMessageProvider.insert(sensorMessage);
    sendMessageAndDeleteIfSuccessful(sensorMessage);
  }


  Future<void> reSendMessage(SensorMessage sensorMessage) async {
    //To move logic from storage to here
    sensorMessage.timeLastRetry = DateTime.now();
    await _sensorMessageProvider.update(sensorMessage);
    sendMessageAndDeleteIfSuccessful(sensorMessage);
  }


  Future<void> sendMessageAndDeleteIfSuccessful(SensorMessage sensorMessage) async {
    try {
      _infoStorage.saveSensorMessageToServer(sensorMessage).then((value) => {
        if (value.statusCode==201)
          {
            _sensorMessageProvider.delete(sensorMessage.id)
          }
      });
    } on TimeoutException {
      print ("Server not responding");
    }
  }
}






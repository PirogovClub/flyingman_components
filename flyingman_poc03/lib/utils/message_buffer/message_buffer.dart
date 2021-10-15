import 'dart:async';
import 'dart:convert';

import 'package:flyingman_poc03/dto/domain/bme_sensor_data.dart';
import 'package:flyingman_poc03/dto/domain/sensor_data.dart';
import 'package:flyingman_poc03/utils/message_buffer/sensor_message.dart';
import 'package:flyingman_poc03/utils/message_buffer/sensor_message_provider.dart';
import 'package:flyingman_poc03/utils/states_dto.dart';
import 'package:http/http.dart';

import 'package:sqflite/sqflite.dart';

import '../storage.dart';

class MessageBuffer {
  List<SensorMessage> _sensor_messages = [];
  final SensorMessageProvider _sensorMessageProvider = SensorMessageProvider();
  final InfoStorage _infoStorage = InfoStorage();

  MessageBuffer()  {


  }

  MessageBuffer returnThis(){
    return this;
  }

  Future<MessageBuffer> init()  async {
    await _infoStorage.getFilePath().then((value) => {
      _sensorMessageProvider.open(value+ "/messageStorage.db")
    }) ;
    Timer.periodic(Duration(minutes: 3), (timer) {
      resendAllMessages();
    });
    return this;
  }

  Future<Response> addMessageToBuffer(SensorMessage sensorMessage) async {
    //TODO: To move logic from storage to here

    sensorMessage.timeAdded = DateTime.now();
    return _sensorMessageProvider
        .insert(sensorMessage)
        .then((value) => sendMessageAndDeleteIfSuccessful(value));
  }

  void resendAllMessages() {
    _sensorMessageProvider.getAllSensorMessages().then((messageList) => {
          for (var sensorMessage in messageList) {reSendMessage(sensorMessage)}
        });
  }

  Future<void> reSendMessage(SensorMessage sensorMessage) async {
    //To move logic from storage to here
    sensorMessage.timeLastRetry = DateTime.now();
    _sensorMessageProvider
        .update(sensorMessage)
        .then((value) => sendMessageAndDeleteIfSuccessful(sensorMessage));
  }

  Future<Response> sendMessageAndDeleteIfSuccessful(
      SensorMessage sensorMessage) async {

    try {
      Future<Response> response =
          _infoStorage.saveSensorMessageToServer(sensorMessage);
      response.then((value) => {
            if (value.statusCode == 201)
              {_sensorMessageProvider.delete(sensorMessage.id)}
          });
/*var jsonD =jsonDecode(sensorMessage.messageBody);
      Future<Response> response =
      _infoStorage.saveSensorDataToDB(BmeSensorsData.fromJson(jsonD),"");
      response.then((value) => {
        if (value.statusCode == 201)
          {_sensorMessageProvider.delete(sensorMessage.id)}
      });*/

      return response;
    } on TimeoutException {
      print("Server not responding");

    }
    throw Exception("should not be here 1");

  }
}

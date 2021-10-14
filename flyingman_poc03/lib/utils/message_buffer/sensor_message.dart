import 'constants.dart';

enum MessageType { phone, bme }

class SensorMessage {
  int id;
  String messageBody;
  String endpoint;
  DateTime timeAdded;
  DateTime timeLastRetry;
  MessageType messageType;
  bool done;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnMessageBody: messageBody,
      columnDone: done == true ? 1 : 0
    };
    map[columnId] = id;
    return map;

  }

  SensorMessage markAsPhoneSensor() {
    messageType = MessageType.phone;
    return this;
  }

  SensorMessage markAsBmeSensor() {
    messageType = MessageType.bme;
    return this;
  }

  SensorMessage({
    required this.id,
    required this.messageBody,
    required this.done,
    required this.endpoint,
    required this.timeAdded,
    required this.timeLastRetry,
    required this.messageType,
  });

  factory SensorMessage.fromMap(Map<String, Object?> map) {
    return SensorMessage(
        id: int.parse(map[columnId].toString()),
        messageBody: map[columnMessageBody].toString(),
        done: (map[columnDone] == 1),
        endpoint: map[columnEndPoint].toString(),
        timeLastRetry: DateTime.parse(map[columnTimeLastRetry].toString()),
        timeAdded: DateTime.parse(map[columnTimeAdded].toString()),
        messageType: map[columnMessageType] as MessageType);
  }
}

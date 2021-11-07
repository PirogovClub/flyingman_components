import 'constants.dart';

class SensorMessage {
  int id;
  String messageBody;
  String endpoint;
  DateTime timeAdded;
  DateTime timeLastRetry;
  String messageType;
  bool done;

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnMessageBody: messageBody,
      columnDone: done == true ? 1 : 0,
      columnEndPoint: endpoint,
      columnTimeAdded: timeAdded.toString(),
      columnTimeLastRetry: timeLastRetry.toString(),
      columnMessageType: "",
      columnId: id
    };

    return map;
  }

  Map<String, Object?> toMapForInsert() {
    var map = <String, Object?>{
      columnMessageBody: messageBody,
      columnDone: done == true ? 1 : 0,
      columnEndPoint: endpoint,
      columnTimeAdded: timeAdded.toString(),
      columnTimeLastRetry: timeLastRetry.toString(),
      columnMessageType: "",

    };
    map[columnId] = null;
    return map;
  }


  SensorMessage markAsPhoneSensor() {
    messageType = "phone";
    return this;
  }

  SensorMessage markAsBmeSensor() {
    messageType = "bme";
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
        messageBody: map[columnMessageBody] as String,
        done: (map[columnDone] == 1),
        endpoint: map[columnEndPoint].toString(),
        timeLastRetry: DateTime.parse(map[columnTimeLastRetry].toString()),
        timeAdded: DateTime.parse(map[columnTimeAdded].toString()),
        messageType: map[columnMessageType] as String);
  }

  @override
  String toString() {
    return "{id:$id;messageBody:$messageBody;endpoint:$endpoint;timeAdded:$timeAdded;timeLastRetry:$timeLastRetry;messageType:$messageType;done:$done}";
  }
}

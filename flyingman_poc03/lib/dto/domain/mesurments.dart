import 'package:flyingman_poc03/dto/domain/users.dart';

class Measurements {
   int id=0;

  final String measurement_uuid;

  final UserData user_id;

   int user_device_id;

   Measurements(
      {
      required this.measurement_uuid,
      required this.user_id,
      required this.user_device_id
      });

  Map<String, dynamic> toJsonToBackEnd() => {
        "id": id,
        "measurement_uuid": measurement_uuid,
        "user_id": user_id.toJsonToBackEnd(),
        "user_device_id": user_device_id
      };

  factory Measurements.fromJson(Map<String, dynamic> json) {
    return Measurements(

      measurement_uuid: json["measurement_uuid"],
      user_id: UserData.fromJson(json["user_id"]),
      user_device_id: json["user_device_id"],
    );
  }
}

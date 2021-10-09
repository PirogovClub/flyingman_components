import 'package:flyingman_poc03/dto/domain/users.dart';

class Measurements {
  final int id;

  final String measurement_uuid;

  final UserData user_id;

  final int user_device_id;

  const Measurements(
      {required this.id,
      required this.measurement_uuid,
      required this.user_id,
      required this.user_device_id});

  Map<String, dynamic> toJsonToBackEnd() => {
        "id": id,
        "measurement_uuid": measurement_uuid,
        "user_id": user_id.toJsonToBackEnd(),
        "user_device_id": user_device_id
      };

  factory Measurements.fromJson(Map<String, dynamic> json) {
    return Measurements(
      id: json["id"],
      measurement_uuid: json["measurement_uuid"],
      user_id: UserData.fromJson(json["userId"]),
      user_device_id: json["user_device_id"],
    );
  }
}

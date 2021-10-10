

class UserData {
  final int id;

  const UserData({required this.id});

  Map<String, dynamic> toJsonToBackEnd() => {
        "id": id,
      };

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(id: json["id"]);
  }
}

import 'dart:convert';

import 'package:flyingman_poc03/dto/domain/bme_sensor_data.dart';

List<BmeSensorsData> parseBmeSensorsData(String responseBody) {
  final parsed = jsonDecode(responseBody);

  return parsed
      .map<List<BmeSensorsData>>((json) => BmeSensorsData.fromJson(json))
      .toList();
}

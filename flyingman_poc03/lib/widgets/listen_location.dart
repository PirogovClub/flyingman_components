import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flyingman_poc03/dto/containers/phone_sensor_container.dart';
import 'package:flyingman_poc03/utils/local_system_time_util.dart';
import 'package:flyingman_poc03/utils/storage.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:sensors_plus/sensors_plus.dart';


class ListenLocationWidget extends StatefulWidget {
  const ListenLocationWidget({Key? key}) : super(key: key);

  @override
  _ListenLocationState createState() => _ListenLocationState();
}

class _ListenLocationState extends State<ListenLocationWidget> {
  final Location location = Location();
  LocalSystemTimeUtil _localSystemTimeUtil = new LocalSystemTimeUtil();
  InfoStorage _counterStorage = new InfoStorage();
  LocationData? _location;
  StreamSubscription<LocationData>? _locationSubscription;
  String? _error;
  String _locationText = "";

  PhoneSensorsContainer sensorsContainer = PhoneSensorsContainer();

  Future<void> _listenLocation() async {
    InfoStorage counterStorage = new InfoStorage();
    List<StreamSubscription> _streamSubscriptions =
    <StreamSubscription<dynamic>>[];
    _streamSubscriptions.add(
      accelerometerEvents.listen(
            (AccelerometerEvent event) {
          sensorsContainer.phoneSensorData.accelerometer_x = event.x;
          sensorsContainer.phoneSensorData.accelerometer_y = event.y;
          sensorsContainer.phoneSensorData.accelerometer_z = event.z;
        },
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEvents.listen(
            (GyroscopeEvent event) {
          sensorsContainer.phoneSensorData.gyroscope_x = event.x;
          sensorsContainer.phoneSensorData.gyroscope_y = event.y;
          sensorsContainer.phoneSensorData.gyroscope_z = event.z;
        },
      ),
    );
    _streamSubscriptions.add(
      userAccelerometerEvents.listen(
            (UserAccelerometerEvent event) {
          sensorsContainer.phoneSensorData.user_accelerometer_x = event.x;
          sensorsContainer.phoneSensorData.user_accelerometer_y = event.y;
          sensorsContainer.phoneSensorData.user_accelerometer_z = event.z;
        },
      ),
    );
    _streamSubscriptions.add(
      magnetometerEvents.listen(
            (MagnetometerEvent event) {
          sensorsContainer.phoneSensorData.magnitometr_x = event.x;
          sensorsContainer.phoneSensorData.magnitometr_y = event.y;
          sensorsContainer.phoneSensorData.magnitometr_z = event.z;
        },
      ),
    );

    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
          if (err is PlatformException) {
            _error = err.code;
          }
          _locationSubscription?.cancel();
        }).listen((LocationData _locationResult) async {
          _error = null;
          var _date = new DateTime.fromMillisecondsSinceEpoch(
              _locationResult.time!.toInt());
          sensorsContainer.phoneSensorData.local_time = new DateTime.now();
          sensorsContainer.phoneSensorData.altitude = _locationResult.altitude!;
          sensorsContainer.phoneSensorData.latitude = _locationResult.latitude!;
          sensorsContainer.phoneSensorData.longitude =
          _locationResult.longitude!;
          sensorsContainer.phoneSensorData.heading = _locationResult.heading!;
          sensorsContainer.phoneSensorData.accuracy = _locationResult.accuracy!;
          sensorsContainer.phoneSensorData.time = new DateTime.now();
          counterStorage
              .savePhoneDataToDB(counterStorage.locationData, "phonedata")
              .then((value) => getBody(value))
              .then((value) =>
          {
            setState(() {
              _locationText = value;
            })
          });
        });
    setState(() {});
  }

  String getBody(Response value) {
    print("body:" + value.body.toString());
    return value.body.toString();
  }

  Future<void> _stopListen() async {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
    super.dispose();
  }

  dynamic myEncode(dynamic item) {
    if (item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Listen location: ' +
              (_error ?? _locationText),
          style: Theme
              .of(context)
              .textTheme
              .bodyText1,
        ),
        Row(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 42),
              child: ElevatedButton(
                child: const Text('Listen'),
                onPressed:
                _locationSubscription == null ? _listenLocation : null,
              ),
            ),
            ElevatedButton(
              child: const Text('Stop'),
              onPressed: _locationSubscription != null ? _stopListen : null,
            )
          ],
        ),
      ],
    );
  }
}

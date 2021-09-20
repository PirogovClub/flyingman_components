import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flyingman_poc03/utils/local_system_time_util.dart';
import 'package:flyingman_poc03/utils/states_dto.dart';
import 'package:flyingman_poc03/utils/states_dto.dart';
import 'package:flyingman_poc03/utils/storage.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';

import 'clock.dart';

class ListenLocationWidget extends StatefulWidget {
  const ListenLocationWidget({Key? key}) : super(key: key);

  @override
  _ListenLocationState createState() => _ListenLocationState();
}

class _ListenLocationState extends State<ListenLocationWidget> {
  final Location location = Location();
  LocalSystemTimeUtil _localSystemTimeUtil = new LocalSystemTimeUtil();
  CounterStorage _counterStorage = new CounterStorage();
  LocationData? _location;
  StreamSubscription<LocationData>? _locationSubscription;
  String? _error;
  String _locationText = "";

  Future<void> _listenLocation() async {
    _locationSubscription =
        location.onLocationChanged.handleError((dynamic err) {
      if (err is PlatformException) {
        setState(() {
          _error = err.code;
        });
      }
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((LocationData _locationResult) async {
      _error = null;
      _location = _locationResult;
      var _date = new DateTime.fromMillisecondsSinceEpoch(
          _locationResult.time!.toInt());
      _locationText = "localTime:" +
          _localSystemTimeUtil.getSystemTime() +
          ";" +
          "altitude:" +
          _locationResult.altitude.toString() +
          ";" +
          "latitude:" +
          _locationResult.latitude.toString() +
          ";" +
          "latitude:" +
          _locationResult.longitude.toString() +
          ";" +
          "heading:" +
          ";" +
          _locationResult.heading.toString() +
          ";" +
          "accuracy:" +
          ";" +
          _locationResult.accuracy.toString() +
          ";" +
          "time:" +
          _date.toString() +
          ";";
      if (StateDto.saveToFile) {
        await _counterStorage.writeStringToFile(_locationText);
      }
      setState(() {});
    });
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Listen location: ' + (_error ?? _locationText ),
          style: Theme.of(context).textTheme.bodyText1,
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

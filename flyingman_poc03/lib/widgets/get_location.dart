import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

class GetLocationWidget extends StatefulWidget {
  const GetLocationWidget({Key? key}) : super(key: key);

  @override
  _GetLocationState createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocationWidget> {
  final Location location = Location();

  bool _loading = false;

  LocationData? _location;
  String _locationText = "";
  String? _error;

  Future<void> _getLocation() async {
    setState(() {
      _error = null;
      _loading = true;
    });
    try {
      final LocationData _locationResult = await location.getLocation();
      setState(() {
        _location = _locationResult;
        var _date = new DateTime.fromMicrosecondsSinceEpoch(_locationResult.time!.toInt());
        _locationText = "altitude:" +
            _locationResult.altitude.toString() +
            "heading:" +
            _locationResult.heading.toString() +
            "accuracy:" +
            _locationResult.accuracy.toString()+
        "time:" +
            _date.hour.toString()+":"+_date.minute.toString()+":"+_date.second.toString();

        _loading = false;
      });
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Location: ' + (_error ?? _locationText ),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        Row(
          children: <Widget>[
            ElevatedButton(
              child: _loading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text('Get'),
              onPressed: _getLocation,
            )
          ],
        ),
      ],
    );
  }
}

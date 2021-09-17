import 'dart:convert';
import 'package:flyingmanPoc1/states/HomePageState.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sensors/sensors.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}
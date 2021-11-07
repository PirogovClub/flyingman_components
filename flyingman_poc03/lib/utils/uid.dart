import 'dart:async';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:device_info/device_info.dart';
import 'package:uuid/uuid.dart';

class Uid {

  String deviceName = "UnableToGetDeviceName";
  String deviceVersion= "UnableToGetDeviceVersion";
  String identifier= "UnableToGetDeviceIdentifier";


  Future<List<String>> getDeviceDetails() async {

    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

//if (!mounted) return;
    return [deviceName, deviceVersion, identifier];
  }

  String getSensorID(String sensorName){
    return Uuid().v5(Uuid.NAMESPACE_OID, sensorName+getDeviceDetails().toString());
  }
}
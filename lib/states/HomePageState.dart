import 'dart:convert';
import 'package:compass/controls/AniControl.dart';
import 'package:compass/controls/Animation.dart';
import 'package:compass/widgets/CountBtnPage.dart';
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

import '../pages/HomePage.dart';

class HomePageState extends State<HomePage> {
  int mode = 0, map = 0;
  AniControl compass;
  AniControl earth;
  double lat, lon;

  String city = '', weather = '', icon = '01d';
  double temp = 0, humidity = 0;

  void getWeather() async {
    var key = '7c5c03c8acacd8dea3abd517ae22af34';
    var url = 'http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$key';
    var resp = await http.Client().get(Uri.parse(url));
    var data = json.decode(resp.body);
    city = data['name'];
    var m = data['weather'][0];
    weather = m['main'];
    icon = m['icon'];
    m = data['main'];
    temp = m['temp'] - 273.15;
    humidity = m['humidity'] + 0.0;
    setState(() {});
  }

  void setLocation(double lati, double long, [bool weather = true]) {
    earth['lat'].value = lat = lati;
    earth['lon'].value = lon = long;
    if (weather) getWeather();
    setState(() {});
  }

  void locate() => Location().getLocation().then((p) => setLocation(p.latitude, p.longitude));

  void _showFilesinDir({Directory dir}) {
    dir.list(recursive: false, followLinks: false)
        .listen((FileSystemEntity entity) {
      print(entity.path);
    });
  }


  @override
  Future<void> initState() async {
    super.initState();


    compass = AniControl([
      Anim('dir', 0, 360, 45, true),
      Anim('hor', -9.6, 9.6, 20, false),
      Anim('ver', -9.6, 9.6, 20, false),
    ]);

    earth = AniControl([
      Anim('dir', 0, 360, 20, true),
      Anim('lat', -90, 90, 1, false),
      Anim('lon', -180, 180, 1, true),
    ]);

    FlutterCompass.events.listen((angle) {

      compass['dir'].value =  angle.heading;
      earth['dir'].value = angle.heading;
      print("FlutterCompass.angle.heading"+ angle.heading.toString());
    });

    accelerometerEvents.listen((event) {
      compass['hor'].value = -event.x;
      compass['ver'].value = -event.y;
      // print("accelerometerEvents.x"+ event.x.toString());
    });

    setLocation(0, 0);
    locate();
  }

  Widget Compass() {
    return GestureDetector(
      onTap: () => setState(() => mode++),
      child: FlareActor("assets/compass.flr", animation: 'mode${mode % 2}', controller: compass),
    );
  }

  Widget Earth() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(city, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      Text('lat:${lat.toStringAsFixed(2)}  lon:${lon.toStringAsFixed(2)}'),
      Expanded(
        child: GestureDetector(
          onTap: () => setState(() => earth.play('mode${++map % 2}')),
          onDoubleTap: locate,
          onPanUpdate: (pan) => setLocation((lat - pan.delta.dy).clamp(-90.0, 90.0), (lon - pan.delta.dx + 180) % 360 - 180, false),
          onPanEnd: (_) => getWeather(),
          child: FlareActor("assets/earth.flr", animation: 'pulse', controller: earth),
        ),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 128, height: 128, child: FlareActor('assets/weather.flr', animation: icon)),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${temp.toInt()}°', style: TextStyle(fontSize: 60)),
          Text(weather),
          Text('Humidity ${humidity.toInt()}%'),
        ]),
      ]),
    ]);
  }

  Widget GetAccess(){
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const CountBtnPage(title: 'Flutter Demo Home Page'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: PageController(viewportFraction: 0.8),
        scrollDirection: Axis.vertical,
        children: [Compass(), Earth()],
      ),
    );
  }
}
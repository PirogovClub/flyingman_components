import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flyingman_poc03/bluetooth/main_bluetooth_page.dart';
import 'package:flyingman_poc03/dto/containers/phone_sensor_container.dart';
import 'package:flyingman_poc03/utils/message_buffer/message_buffer.dart';
import 'package:flyingman_poc03/widgets/clock.dart';
import 'package:flyingman_poc03/widgets/get_location.dart';
import 'package:flyingman_poc03/widgets/listen_location.dart';
import 'package:flyingman_poc03/widgets/permission_status_widget.dart';
import 'package:flyingman_poc03/widgets/send_to_server.dart';
import 'package:flyingman_poc03/widgets/sensors.dart';
import 'package:flyingman_poc03/widgets/service_enabled.dart';
import 'package:flyingman_poc03/utils/states_dto.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);
   PhoneSensorsContainer phoneSensorsContainer = PhoneSensorsContainer();
    static  MessageBuffer messageBuffer =  MessageBuffer();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flying Man DataCollection",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Recording Data'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;



  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  Color headerIconColor = Colors.white;
  Color headerIconBgColor = Colors.red;
  double iconSize = 20;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _changeRecordingStatus() {
    StateDto.setSaveToFile(!StateDto.saveToFile);
    headerIconColor = StateDto.saveToFile ? Colors.red : Colors.white;
    headerIconBgColor = StateDto.saveToFile ? Colors.green : Colors.red;
    iconSize = StateDto.saveToFile ? 30 : 20;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                setState(() {
                  _changeRecordingStatus();
                });
              },
              icon: Icon(StateDto.saveToFile
                  ? Icons.stop
                  : Icons.fiber_manual_record_sharp),
              color: headerIconColor)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PermissionStatusWidget(),
            Divider(height: 32),
            ServiceEnabledWidget(),
            Divider(height: 32),
            ListenLocationWidget(),
            Divider(height: 32),
            DigitalClockWidget(),
            Divider(height: 32),
            SensorsWidget(),
            Divider(height: 32),
            SendToServerWidget(),
            Divider(height: 32),
            BlueToothWidget()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await MyApp.messageBuffer.init();
          setState(() {
            _changeRecordingStatus();
          });
        },
        tooltip: 'Increment',
        child: Icon(
          StateDto.saveToFile ? Icons.stop : Icons.fiber_manual_record_sharp,
          color: headerIconColor,
          size: iconSize,
        ),
        backgroundColor: headerIconBgColor,
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Main Menu'),
            ),
            ListTile(
              title: const Text('Permissions'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.of(context).push( MaterialPageRoute(
                  builder: (context) {
                    return const PermissionStatusWidget();
                  },
                ),);
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }
}

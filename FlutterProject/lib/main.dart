import 'package:FlutterProject/GHFlutterMainPage.dart';
import 'package:FlutterProject/flutterengine/GHNativeEngine.dart';
import 'package:FlutterProject/flutterengine/GHNativeSystemChannel.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // 注册channel
    GHNativeEngine.singleton.registerChannelMethods({
      'com.gh.channel.system': () => GHNativeSystemChannel(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Container(),
      routes: {
        'GHFlutterMainPage' : (context) => GHFlutterMainPage(),
      },
    );
  }
}

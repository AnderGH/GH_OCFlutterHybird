import 'package:FlutterProject/flutterengine/GHNativeSystemChannel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GHFlutterMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '首页',
        ),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            GHNativeSystemChannel.closeFlutter();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text('修改状态栏'),
              onPressed: () {
                GHNativeSystemChannel.changeStatusBar(GHStatusBarStyle.light);
              },
            ),
            RaisedButton(
              child: Text('拦截侧划'),
              onPressed: () {
                GHNativeSystemChannel.startHookSystemBackAction(() {
                  print('SystemBackActionCall');
                });
              },
            ),
            RaisedButton(
              child: Text('恢复侧划'),
              onPressed: () {
                GHNativeSystemChannel.endHookSystemBackAction();
              },
            ),
          ],
        ),
      ),
    );
  }
}

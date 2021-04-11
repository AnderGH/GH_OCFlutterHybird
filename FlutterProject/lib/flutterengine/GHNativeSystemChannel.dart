
import 'dart:convert';

import 'package:FlutterProject/flutterengine/GHNativeEngine.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

enum GHStatusBarStyle {
  dark,
  light,
}

class GHNativeSystemChannel extends GHMethodChannel {

  static MethodChannel get _channel {
    return GHMethodChannel.methodChannel(GHNativeSystemChannel);
  }

  @override
  Future receiveNativeMethodCall(String method, arguments) {
    if (method == 'systemBackCall') {
      return systemBackCall();
    }
    return super.receiveNativeMethodCall(method, arguments);
  }

  static void closeFlutter() {
    try {
      _channel.invokeMethod('closeFlutter');
    } catch (e) {
      throw (e);
    }
  }

  /// 修改iOS状态栏颜色
  static void changeStatusBar(GHStatusBarStyle style) {
    try {
      final params = {
        'light': style == GHStatusBarStyle.dark ? false : true,
      };
      _channel.invokeMethod('changeStatusBar', json.encode(params));
    } catch (e) {
      throw (e);
    }
  }

  static VoidCallback _systemBackCall;
  /// 开始拦截系统返回方法
  static void startHookSystemBackAction(VoidCallback callback) {
    try {
      _systemBackCall = callback;
      _channel.invokeMethod('startHookSystemBackAction');
    } catch (e) {
      throw (e);
    }
  }

  /// 停止拦截系统返回方法
  static void endHookSystemBackAction() {
    try {
      _systemBackCall = null;
      _channel.invokeMethod('endHookSystemBackAction');
    } catch (e) {
      throw (e);
    }
  }

  /// 系统返回手势触发
  Future systemBackCall() async {
    _systemBackCall();
  }
}

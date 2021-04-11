import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

typedef GHChannelBuilder = GHMethodChannel Function();

class GHNativeEngine {
  // 单例
  static final GHNativeEngine _instance = GHNativeEngine();
  static GHNativeEngine get singleton => _instance;

  /// channel 列表，key为method 类的 type，value 为MethodChannel对象
  Map<String, MethodChannel> _channels = {};

  /// 注册与原生通信的channel
  void registerChannelMethods(Map<String, GHChannelBuilder> map) {
    for (String channelName in map.keys) {
      GHChannelBuilder builder = map[channelName];
      final method = builder();

      // 创建channel
      MethodChannel methodChannel = MethodChannel(channelName);
      // 将method的type作为名称，组成新的map
      _channels[method.runtimeType.toString()] = methodChannel;

      /// 接收native主动发起的通信
      methodChannel.setMethodCallHandler((call) {
        // 传递给对应的method
        return method.receiveNativeMethodCall(call.method, call.arguments);
      });
    }
  }

  /// 按约定格式生成路由地址
  ///
  /// [routerName] 路由名称
  /// [flutterPage] 是否是flutter页面，默认true
  static String router(String routerName, [bool flutterPage]) {
    if (flutterPage != null && !flutterPage) {
      return 'native://com.gh?pagename=' + routerName;
    }
    return 'flutter://com.gh?pagename=' + routerName;
  }
}

/// 每个channel类需要extends此类，此类提供获取对应MethodChannel的静态方法
class GHMethodChannel {
  /// 根据类型获取MethodChannel对象的方法
  static MethodChannel methodChannel<T extends GHMethodChannel>(T) {
    return GHNativeEngine.singleton._channels[T.toString()];
  }

  /// 接收native主动发起的通信
  @required
  Future<dynamic> receiveNativeMethodCall(
      String method, dynamic arguments) async {}
}

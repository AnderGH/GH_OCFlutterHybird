//
//  GHFlutterSystemChannel.swift
//  NativeProject
//
//  Created by apple on 2020/12/1.
//

import UIKit
import Flutter

class GHFlutterSystemChannel: GHFlutterProtocol {
    
    var channel: FlutterMethodChannel!
    
    // 缓存channel对象
    func cacheChannel(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    // 接收flutter方法
    func receive(_ method: String, arguments: Any?, result: @escaping (Any) -> Void) {
        // 关闭flutter容器
        if method == "closeFlutter" {
            GHFlutterEngine.instance.close(nil);
        }
        // 改变状态栏风格
        if method == "changeStatusBar" {
            // 解析参数
            guard let arguments = dictionary(from: arguments) else {
                return
            }
            guard let light: Bool = arguments["light"] as? Bool else {
                return
            }
            var statusBarStyle: UIStatusBarStyle!
            if #available(iOS 13.0, *) {
                statusBarStyle = light ? .lightContent : .darkContent
            } else {
                statusBarStyle = light ? .lightContent : .default
            }
            (GHFlutterEngine.instance.topViewController as? GHFlutterBaseViewController)?.changeStatusStyle(style: statusBarStyle)
            return
        }
        // 开始拦截系统返回方法，iOS为系统侧划
        if method == "startHookSystemBackAction" {
            (GHFlutterEngine.instance.topViewController as? GHFlutterBaseViewController)?.interactivePopGestureAction = { [weak self] () -> Void in
                // 回调时给flutter发送消息
                self?.channel.invokeMethod("systemBackCall", arguments: nil, result: nil)
            }
        }
        // 开始拦截系统返回方法，iOS为系统侧划
        if method == "endHookSystemBackAction" {
            (GHFlutterEngine.instance.topViewController as? GHFlutterBaseViewController)?.interactivePopGestureAction = nil
        }
    }
}

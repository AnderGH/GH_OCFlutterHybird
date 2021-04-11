//
//  GHFlutterEngine.swift
//  NativeProject
//
//  Created by apple on 2020/11/30.
//

import UIKit
import Flutter
import FlutterPluginRegistrant

class GHFlutterEngine: NSObject {
    
    // 单例方法
    static let instance: GHFlutterEngine = GHFlutterEngine.init()
    
    private override init() {}
    
    let flutterEngine = FlutterEngine(name: "gh flutter engine")
        
    /// 启动flutter环境的方法
    /// - Parameter channels: flutter通道
    func startFlutter(_ channels: [String : GHFlutterProtocol]) {
        
        // 启动FlutterEngine
        self.flutterEngine.run();
        GeneratedPluginRegistrant.register(with: self.flutterEngine);
        
        // 创建channel
        channels.forEach { (element: (key: String, value: GHFlutterProtocol)) in
            // 初始化channel
            let flutterMethodChannel: FlutterMethodChannel = FlutterMethodChannel.init(name: element.key, binaryMessenger: self.flutterEngine.binaryMessenger)
            flutterMethodChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
                // 传递参数
                element.value.receive(call.method, arguments: call.arguments, result: result)
            }
            // 将创建的channel保存起来
            element.value.cacheChannel(channel: flutterMethodChannel)
        }
    }
    
    // 最顶部的控制器
    var topViewController: UIViewController? {
        var rootViewController: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController
        while true {
            guard let r = rootViewController else {
                break
            }
            if let presentedViewController = r.presentedViewController {
                rootViewController = presentedViewController
            } else {
                while true {
                    guard let a = rootViewController else {
                        break
                    }
                    if a.isKind(of: UIAlertController.self) {
                        rootViewController = a.presentingViewController
                    } else {
                        break
                    }
                }
                break
            }
        }
        while true {
            guard let r = rootViewController else {
                break
            }
            if r.isKind(of: UINavigationController.self) {
                rootViewController = (r as? UINavigationController)?.topViewController
            } else if r.isKind(of: UITabBarController.self) {
                rootViewController = (r as? UITabBarController)?.selectedViewController
            } else {
                break
            }
        }
        return rootViewController
    }
    
    // open方法
    func open(_ url: String, Params: [AnyHashable : Any]?, completion: ((Bool) -> Void)?) {
        GHFlutterPlatform.open(url, Params: Params, completion: completion)
    }
    
    // present方法
    func present(_ url: String, Params: [AnyHashable : Any]?, completion: ((Bool) -> Void)?) {
        GHFlutterPlatform.present(url, Params: Params, completion: completion)
    }
    
    // close方法
    func close(_ params: [AnyHashable : Any]?) {
        GHFlutterPlatform.close(params);
    }
}

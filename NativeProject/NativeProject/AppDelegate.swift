//
//  AppDelegate.swift
//  NativeProject
//
//  Created by apple on 2020/11/30.
//

import UIKit
import Flutter

@main
class AppDelegate: FlutterAppDelegate {
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // 启动Flutter引擎
        GHFlutterEngine.instance.startFlutter(
            [
                "com.gh.channel.system" : GHFlutterSystemChannel.init(),
            ]
        )
        
        // 初始化
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        window?.rootViewController = GHBaseNavigationController.init(rootViewController: NativeMainViewController.init())
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

}


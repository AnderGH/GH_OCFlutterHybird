//
//  GHFlutterPlatform.swift
//  NativeProject
//
//  Created by apple on 2020/12/1.
//

import UIKit

class GHFlutterPlatform {
    
    // 实现push方法
    class func open(_ url: String, Params: [AnyHashable : Any]?, completion: ((Bool) -> Void)?) {
        
        // 是否需要系统动画
        var animated: Bool = true
        if let a = Params?["animated"] as? Bool {
            animated = a
        }
        // 是否是present
        var present: Bool = false
        if let p = Params?["present"] as? Bool {
            present = p
        }
        // present是否需要全屏，仅在present=true时有效
        var fullScreen: Bool = true
        if let f = Params?["fullScreen"] as? Bool {
            fullScreen = f
        }
        
        // flutter://com.gh?pagename=xxx
        // native://com.gh?pagename=xxx
        // 获取需要打开的类名
        guard let params: String = url.components(separatedBy: "?").last else {
            print("路径参数错误")
            completion?(false)
            return
        }
        var pageName: String = ""
        for p in params.components(separatedBy: "&") {
            if p.hasPrefix("pagename") {
                pageName = p.components(separatedBy: "=").last ?? ""
                break
            }
        }
        if pageName == "" {
            print("路径参数错误")
            completion?(false)
            return
        }
        
        var target: GHFlutterBaseViewController?
        // 与flutter约定前缀
        if url.hasPrefix("flutter://") {
            // 生成新的flutter容器
            target = GHFlutterBaseViewController.init(engine: GHFlutterEngine.instance.flutterEngine, nibName: nil, bundle: nil)
            target?.pushRoute(pageName);
            
        } else if url.hasPrefix("native://") {
            // 获取需要打开的原生类名
            guard let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else {
                print("app名称错误")
                completion?(false)
                return
            }
            let ac: AnyClass? = NSClassFromString(appName + "." + pageName)
            guard let t: GHFlutterBaseViewController.Type = ac as? GHFlutterBaseViewController.Type else {
                print("路径参数错误")
                completion?(false)
                return
            }
            target = t.init(coder: NSCoder.init())
        } else {
            print("路径参数错误")
            completion?(false)
            return
        }
        
        guard let t = target else {
            print("路径参数错误")
            completion?(false)
            return
        }
        if present {
            if fullScreen {
                t.modalPresentationStyle = .fullScreen
            }
            GHFlutterEngine.instance.topViewController?.present(t, animated: animated, completion: nil)
        } else {
            GHFlutterEngine.instance.topViewController?.navigationController?.pushViewController(t, animated: animated)
        }
        completion?(true)
    }
    
    // present
    class func present(_ url: String, Params: [AnyHashable : Any]?, completion: ((Bool) -> Void)?) {
        var params = Params
        params?["present"] = 1
        open(url, Params: params, completion: completion)
    }
    
    // 关闭
    class func close(_ params: [AnyHashable : Any]?) {
        
        // 是否需要系统动画
        var animated: Bool = true
        if let a = params?["animated"] as? Bool {
            animated = a
        }
        GHFlutterEngine.instance.topViewController?.navigationController?.popViewController(animated: animated)
    }
}

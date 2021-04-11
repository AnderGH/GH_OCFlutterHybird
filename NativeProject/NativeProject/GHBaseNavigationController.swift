//
//  GHBaseNavigationController.swift
//  NativeProject
//
//  Created by apple on 2020/11/30.
//

import UIKit

class GHBaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    override var prefersStatusBarHidden: Bool {
        get {
            if let topViewController = self.topViewController as? UITabBarController {
                return topViewController.selectedViewController?.prefersStatusBarHidden ?? false
            }
            return self.topViewController?.prefersStatusBarHidden ?? false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            if let topViewController = self.topViewController as? UITabBarController {
                if #available(iOS 13.0, *) {
                    return topViewController.selectedViewController?.preferredStatusBarStyle ?? .darkContent
                } else {
                    return topViewController.selectedViewController?.preferredStatusBarStyle ?? .default
                }
            }
            if #available(iOS 13.0, *) {
                return self.topViewController?.preferredStatusBarStyle ?? .darkContent
            } else {
                return self.topViewController?.preferredStatusBarStyle ?? .default
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.topViewController?.isKind(of: GHFlutterBaseViewController.self) ?? false {
            return true
        }
        return false
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let vc: GHFlutterBaseViewController = self.topViewController as? GHFlutterBaseViewController else {
            return true
        }
        // 触发回调
        if let action = vc.interactivePopGestureAction {
            action()
            return false
        }
        return true
    }
    
}

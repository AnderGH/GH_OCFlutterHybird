//
//  GHFlutterBaseViewController.swift
//  NativeProject
//
//  Created by apple on 2020/11/30.
//

import UIKit
import Flutter

class GHFlutterBaseViewController: FlutterViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // MARK: status bar
    
    lazy var statusBarStyle: UIStatusBarStyle = {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }()
    
    private var statusBarHidden: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return statusBarStyle
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return statusBarHidden
        }
    }
    
    /// 改变状态栏风格的方法
    /// - Parameter style: UIStatusBarStyle
    func changeStatusStyle(style: UIStatusBarStyle) {
        statusBarStyle = style
        setNeedsStatusBarAppearanceUpdate()
    }
    
    /// 状态栏显示/隐藏
    /// - Parameter hidden: hidden
    func changeStatusHidden(hidden: Bool) {
        statusBarHidden = hidden
        setNeedsStatusBarAppearanceUpdate()
    }
    
    // MARK: interactivePopGestureRecognizer
    
    /// 系统导航栏侧划手势
    var interactivePopGestureAction: (() -> Void)?
}

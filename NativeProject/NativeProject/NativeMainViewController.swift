//
//  NativeMainViewController.swift
//  NativeProject
//
//  Created by apple on 2020/11/30.
//

import UIKit

class NativeMainViewController: GHBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "首页"
        self.view.backgroundColor = UIColor.white
        
        let button: UIButton = UIButton.init(type: .system)
        button.frame = CGRect.init(x: 0, y: 0, width: 200, height: 50)
        button.center = self.view.center
        button.setTitle("open flutter page", for: .normal)
        button.addTarget(self, action: #selector(openFlutterPage), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    // 打开flutter页面
    @objc func openFlutterPage() {
        GHFlutterEngine.instance.open("flutter://com.gh?pagename=GHFlutterMainPage", Params: nil, completion: nil)
    }
    
}

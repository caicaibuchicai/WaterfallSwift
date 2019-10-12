//
//  ViewController.swift
//  WaterfallSwift
//
//  Created by admin on 2019/10/11.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      // 创建一个常规的button
        let button = UIButton(type:.custom)
        button.frame = CGRect(x:10, y:84, width:300, height:30)
        button.setTitle("点击展示瀑布流", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: #selector(buttonClick(button:)), for: .touchUpInside)
        self.view.addSubview(button)
        
    }
    //带参数点击事件
    @objc func buttonClick(button:UIButton ){
      self.present(WaterfallViewController.init(), animated: true, completion: nil)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      
    }
}


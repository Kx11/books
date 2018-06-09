//
//  ViewController.swift
//  Mybook
//
//  Created by 伊藤慶 on 2018/06/10.
//  Copyright © 2018年 伊藤慶. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //hello
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


    extension UIView {
        
        // 枠線の色
        @IBInspectable var borderColor: UIColor? {
            get {
                return layer.borderColor.map { UIColor(cgColor: $0) }
            }
            set {
                layer.borderColor = newValue?.cgColor
            }
        }
        
        // 枠線のWidth
        @IBInspectable var borderWidth: CGFloat {
            get {
                return layer.borderWidth
            }
            set {
                layer.borderWidth = newValue
            }
        }
        
        // 角丸設定
        @IBInspectable var cornerRadius: CGFloat {
            get {
                return layer.cornerRadius
            }
            set {
                layer.cornerRadius = newValue
                layer.masksToBounds = newValue > 0
            }
        }
    }


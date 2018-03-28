//
//  RoundedButton.swift
//  booq
//
//  Created by 中田　優樹 on 2018/03/26.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import UIKit

@IBDesignable
class RoundedButtonm: UIButton {
    
    @IBInspectable var textColor: UIColor?
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
//    var cornerRadius = 5{
//        didset
//    }
    
    
//    layer.cornerRadius = 10
//    layer.masksToBounds = false
//
//    rgstButton.layer.shadowColor = UIColor.black.cgColor
//    rgstButton.layer.shadowOpacity = 0.5 // 透明度
//    rgstButton.layer.shadowOffset = CGSize(width: 5, height: 5) // 距離
//    rgstButton.layer.shadowRadius = 5 // ぼかし量
}


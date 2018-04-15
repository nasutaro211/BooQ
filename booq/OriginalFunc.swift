//
//  OriginalFunc.swift
//  booq
//
//  Created by 中田　優樹 on 2018/04/15.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    //本から画像を登録
    func setImage(of theBook: Book){
        self.sd_setImage(with:URL(string: theBook.imageLink), completed: nil)
        if self.image == nil {
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
            let documentURL = URL(fileURLWithPath: documentsPath)
            let imageURL = documentURL.appendingPathComponent(theBook.ISBN)
            let imagePath = imageURL.path
            self.image = UIImage(contentsOfFile: imagePath)
        }
    }
}

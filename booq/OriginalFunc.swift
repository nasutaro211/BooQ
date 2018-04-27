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

func resizeImage(image :UIImage, w:Int, h:Int) ->UIImage
{
    // アスペクト比を維持
    let origRef    = image.cgImage
    let origWidth  = Int(origRef!.width)
    let origHeight = Int(origRef!.height)
    var resizeWidth:Int = 0, resizeHeight:Int = 0
    if (origWidth < origHeight) {
        resizeWidth = w
        resizeHeight = origHeight * resizeWidth / origWidth
    } else {
        resizeHeight = h
        resizeWidth = origWidth * resizeHeight / origHeight
    }
    
    let resizeSize = CGSize.init(width: CGFloat(resizeWidth), height: CGFloat(resizeHeight))
    
    UIGraphicsBeginImageContextWithOptions(resizeSize, false, 0.0)
    
    image.draw(in: CGRect.init(x: 0, y: 0, width: CGFloat(resizeWidth), height: CGFloat(resizeHeight)))
    
    let resizeImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return resizeImage!
}

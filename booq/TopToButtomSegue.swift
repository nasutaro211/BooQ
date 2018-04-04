//
//  TopToButtomSegue.swift
//  booq
//
//  Created by 中田　優樹 on 2018/04/05.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit

class TopToButtomSegue: UIStoryboardSegue {
    override func perform() {
        var firstVCView = self.source.view as UIView!
        var secondVCView = self.destination.view as UIView!
        
        // Get the screen width and height.
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Specify the initial position of the destination view.
        secondVCView?.frame = CGRect(x: 0.0,y: 0,width: -screenWidth, height: screenHeight)
        
        // Access the app's key window and insert the destination view above the current (source) one.
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondVCView!, aboveSubview: firstVCView!)
        
        // Animate the transition.
        UIView.animate(withDuration: 2, animations: { () -> Void in
            firstVCView?.frame = CGRect(x: 0, y: 0, width: 500, height: 1500)//.offsetBy(CGRect(x: (firstVCView?.frame)!,y:  0.0, screenHeight))
            secondVCView?.frame = CGRect(x: 0, y: 0, width: 500, height: 1500)//ffset((secondVCView?.frame)!, 0.0, screenHeight)
            
        }) { (Finished) -> Void in
            self.source.present(self.destination as! UIViewController,
                                                            animated: false,
                                                            completion: nil)
        }

}
}

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
        let firstVCView = self.source.view as UIView?
        let secondVCView = self.destination.view as UIView?
        
        // Get the screen width and height.
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        // Specify the initial position of the destination view.
        secondVCView?.frame = CGRect(x: 0,y: 0,width: screenWidth, height: screenHeight)
        
        // Access the app's key window and insert the destination view above the current (source) one.
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondVCView!, at: 0)
        
        // Animate the transition.
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            firstVCView?.center.y += screenHeight
        }) { (Finished) -> Void in
            self.source.present(self.destination as! UIViewController,
                                                            animated: false,
                                                            completion: nil)
        }

}
}

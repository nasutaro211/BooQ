//
//  TabBarController.swift
//  
//
//  Created by 中田　優樹 on 2018/04/02.
//

import UIKit

class TabBarController: UITabBarController {
    
        var willAppear = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
            self.selectedIndex = willAppear // 0 が一番左のタ
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

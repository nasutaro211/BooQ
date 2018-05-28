//
//  CheckQuestionViewController.swift
//  booq
//
//  Created by 梶原大進 on 2018/05/24.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit

class CheckQuestionViewController: UIViewController {
    
    @IBOutlet var toRandBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //いらん気がする
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "modal"{
//            let book = sender as! Book
//            let destination = segue.destination as! PopUpViewController
//            destination.theBook = book
//        }
//    }
}

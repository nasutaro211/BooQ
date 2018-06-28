//
//  TodayCheckViewController.swift
//  booq
//
//  Created by 梶原大進 on 2018/06/24.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import RealmSwift

class TodayCheckViewController: UIViewController {
    
    var questions: Results<Question>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        questions = realm.objects(Question.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

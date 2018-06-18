//
//  EachQuestionViewController.swift
//  booq
//
//  Created by 梶原大進 on 2018/06/18.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import RealmSwift

class EachQuestionViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var backCardBtn: UIButton!
    @IBOutlet var iKnowBtn: UIButton!
    @IBOutlet var iDontKnowBtn: UIButton!
    @IBOutlet var rememberBtn: UIButton!
    @IBOutlet var forgetBtn: UIButton!
    
    var theBook: Book!
    var questions: Results<Question>!
    var randomNumbers: [Int] = []
    var doYouKnow = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //選択された本のqeustionsをとる
        questions = theBook.questions.sorted(byKeyPath: "numInBook", ascending: false)
        print("hoge")
        
        //scrolviewの設定
        scrollView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

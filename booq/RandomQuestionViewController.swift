//
//  RandomQuestionViewController.swift
//  booq
//
//  Created by 梶原大進 on 2018/05/24.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import RealmSwift

class RandomQuestionViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var backCardBtn: UIButton!
    
    var questions: Results<Question>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //qeustionsをとる
        let realm = try! Realm()
        questions = realm.objects(Question.self)
        
        backCardBtn.alpha = 0
        
        //ScrollViewの設定
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: 300, height: 200 * questions.count)
        
        //乱数配列作成
        var randomNumbers: [Int] = []
        for i in 0...questions.count-1 {
            randomNumbers.append(i)
        }
        for _ in 0...questions.count/2 {
            let rand_1 = arc4random_uniform(UInt32(questions.count))
            let rand_2 = arc4random_uniform(UInt32(questions.count))
            randomNumbers.swapAt(Int(rand_1), Int(rand_2))
        }
        //label配置
        for i in randomNumbers {
            let questionLabel = UILabel(frame: CGRect(x: 10, y: 30+200*i, width: 280, height: 100))
            questionLabel.textAlignment = NSTextAlignment.center
            questionLabel.font = UIFont.systemFont(ofSize: 20)
            questionLabel.text = questions[i].questionStr
            questionLabel.backgroundColor = UIColor.brown
            scrollView.addSubview(questionLabel)
        }
        //確認よう　あとで消すんやで
        let label = UILabel(frame: CGRect(x: 0, y: 200*questions.count-30, width: 300, height: 30))
        label.backgroundColor = UIColor.black
        scrollView.addSubview(label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func iKnowBtnAc() {
        self.slideScrollView(slideWidth: 200)
    }
    
    @IBAction func iDontKnowBtnAc() {
        self.slideScrollView(slideWidth: 200)
    }
    
    @IBAction func backCardAc() {
        self.slideScrollView(slideWidth: -200)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if Int(scrollView.contentOffset.y) == 0 {
            backCardBtn.alpha = 0
        } else {
            backCardBtn.alpha = 1
        }
    }
    
    func slideScrollView(slideWidth: CGFloat) {
        //もうちょい綺麗にできそう
        switch slideWidth {
        case 200:
            if Int(scrollView.contentOffset.y) <= questions.count*200-400 {
                var offset = CGPoint()
                offset.x = scrollView.contentOffset.x
                offset.y = scrollView.contentOffset.y + slideWidth
                scrollView.setContentOffset(offset, animated: true)
            } else {
                print("スクロールできませーんwwwww")
            }
        case -200:
            if Int(scrollView.contentOffset.y) >= 0 {
                var offset = CGPoint()
                offset.x = scrollView.contentOffset.x
                offset.y = scrollView.contentOffset.y + slideWidth
                scrollView.setContentOffset(offset, animated: true)
            } else {
                print("スクロールできませーんwwwww")
            }
        default:
            print("エラー")
        }
    }

}

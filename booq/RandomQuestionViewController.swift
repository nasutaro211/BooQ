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
    @IBOutlet var iKnowBtn: UIButton!
    @IBOutlet var iDontKnowBtn: UIButton!
    @IBOutlet var rememberBtn: UIButton!
    @IBOutlet var forgetBtn: UIButton!
    
    var questions: Results<Question>!
    var randomNumbers: [Int] = []
    var doYouKnow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //qeustionsをとる
        let realm = try! Realm()
        questions = realm.objects(Question.self)
        
        backCardBtn.alpha = 0
        rememberBtn.alpha = 0
        forgetBtn.alpha = 0
        
        //ScrollViewの設定
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: 300, height: 200 * questions.count + 200)
        scrollView.backgroundColor = UIColor.cyan
        
        //乱数配列作成
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
            let questionLabel = UILabel(frame: CGRect(x: 10, y: 200*i, width: 280, height: 100))
            questionLabel.textAlignment = NSTextAlignment.center
            questionLabel.font = UIFont.systemFont(ofSize: 20)
            questionLabel.text = questions[randomNumbers[i]].questionStr
            questionLabel.backgroundColor = UIColor.brown
            scrollView.addSubview(questionLabel)
        }
        let endBtn = UIButton(frame: CGRect(x: 25, y: 200*questions.count+25, width: 250, height: 150))
        endBtn.addTarget(self, action: #selector(RandomQuestionViewController.endBtnAc(sender:)), for: .touchUpInside)
        endBtn.backgroundColor = UIColor.brown
        endBtn.titleLabel?.textAlignment = NSTextAlignment.center
        endBtn.titleLabel?.text = "終了"
        endBtn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        scrollView.addSubview(endBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func iKnowBtnAc() {
        self.slideScrollView(slideWidth: 200)
    }
    
    @IBAction func iDontKnowBtnAc() {
        backCardBtn.alpha = 0
        iKnowBtn.alpha = 0
        rememberBtn.alpha = 1
        self.view.insertSubview(iKnowBtn, belowSubview: rememberBtn)
        iDontKnowBtn.alpha = 0
        forgetBtn.alpha = 1
        self.view.insertSubview(iDontKnowBtn, belowSubview: forgetBtn)
        
        //ページ数取得
        let pageNumber = Int(scrollView.contentOffset.y)/200
        print("pageNumber = " + String(pageNumber))
        let answerLabel = UILabel(frame: CGRect(x: 10, y: 100+200*pageNumber, width: 280, height: 100))
        answerLabel.tag = pageNumber + 1 //anwerLabelのtagはページ数＋１
        answerLabel.textAlignment = NSTextAlignment.center
        answerLabel.font = UIFont.systemFont(ofSize: 20)
        answerLabel.text = questions[randomNumbers[pageNumber]].answers[0].answerStr
        answerLabel.backgroundColor = UIColor.brown
        scrollView.addSubview(answerLabel)
    }
    
    @IBAction func backCardAc() {
        self.slideScrollView(slideWidth: -200)
    }
    
    @IBAction func rememberAc() {
        backCardBtn.alpha = 1
        iKnowBtn.alpha = 1
        rememberBtn.alpha = 0
        self.view.insertSubview(rememberBtn, belowSubview: iKnowBtn)
        iDontKnowBtn.alpha = 1
        forgetBtn.alpha = 0
        self.view.insertSubview(forgetBtn, belowSubview: iDontKnowBtn)
        
        deleteAnswerLabel()
        slideScrollView(slideWidth: 200)
    }
    
    @IBAction func forgetAc() {
        backCardBtn.alpha = 1
        iKnowBtn.alpha = 1
        rememberBtn.alpha = 0
        self.view.insertSubview(rememberBtn, belowSubview: iKnowBtn)
        iDontKnowBtn.alpha = 1
        forgetBtn.alpha = 0
        self.view.insertSubview(forgetBtn, belowSubview: iDontKnowBtn)
        
        deleteAnswerLabel()
        slideScrollView(slideWidth: 200)
    }
    
    func deleteAnswerLabel() {
        let pageNumber = Int(scrollView.contentOffset.y)/200 + 1
        if scrollView.viewWithTag(pageNumber) != nil {
            print(String(pageNumber) + "ページの答え消すでー")
            scrollView.viewWithTag(pageNumber)?.removeFromSuperview()
        }
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
            if Int(scrollView.contentOffset.y) <= questions.count*200-200 {
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
    
    @objc func endBtnAc(sender: UIButton) {
        let storyboard: UIStoryboard = self.storyboard!
        let second = storyboard.instantiateViewController(withIdentifier: "resultQuestion")
        self.present(second, animated: true, completion: nil)
    }

}

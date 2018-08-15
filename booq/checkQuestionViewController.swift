//
//  CheckQuestionViewController.swift
//  booq
//
//  Created by 梶原大進 on 2018/05/24.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import RealmSwift

class CheckQuestionViewController: UIViewController {
    
    @IBOutlet var toRandBtn: UIButton!
    
    var questions: Results<Question>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //qeustionsをとる
        let realm = try! Realm()
        questions = realm.objects(Question.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func toTodayCheckBtnAc() {
        let realm = try! Realm()
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let today_date = Int(formatter.string(from: today) )! + 1
        let sendQuestions = realm.objects(Question.self).filter("nextEmergenceDay <= %@", today_date)
        if sendQuestions.count == 0 {
            let alert: UIAlertController = UIAlertController(title: "警告", message: "問いがありません", preferredStyle: UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        } else {
            print("チェックしちゃうデー")
            let segue = self.storyboard?.instantiateViewController(withIdentifier: "TodayCheck") as! TodayCheckViewController
            segue.questions = sendQuestions
            self.present(segue, animated: true, completion: nil)
        }
    }
    
    @IBAction func toRandomBtnAc() {
        if questions.count == 0 {
            print("遷移したあかんで")
            let alert: UIAlertController = UIAlertController(title: "警告", message: "本が登録されていません", preferredStyle:  UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        } else {
            print("遷移してええで")
            let segue = self.storyboard?.instantiateViewController(withIdentifier: "RandomQuestion") as! RandomQuestionViewController
            self.present(segue, animated:true, completion: nil)
        }
    }
    
    @IBAction func toEachBookBtn() {
        let segue = self.storyboard?.instantiateViewController(withIdentifier: "EachBookQuestion") as! EachBookQustionViewController
        self.present(segue, animated: true, completion: nil)
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

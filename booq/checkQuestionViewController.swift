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

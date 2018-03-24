//
//  QuestionRgstViewController.swift
//  booq
//
//  Created by 中田　優樹 on 2018/03/21.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import RealmSwift

class QuestionRgstViewController: UIViewController {
    @IBOutlet var bookImageView: UIImageView!
    @IBOutlet var bookTitleLabel: UILabel!
    @IBOutlet var questionTextField: UITextView!
    @IBOutlet var answerTextField: UITextView!
    var theBook: Book!
    var question = ""
    var answers:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: theBook.imageLink)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        bookImageView.image  = image
        bookTitleLabel.text = theBook.title

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPushRgstAndCntnue(_ sender: Any) {
        if questionTextField.text != "" && answerTextField.text != "" {
            //どちらも埋まっている時
            answers.append(answerTextField.text)
            rgstQ()
            answerTextField.text = ""
            questionTextField.text = ""
        }else{
            //どちらかが空白の時
        }
        
    }
    
    
    
    //answersに空白以外のtextfieldのtextを代入して、questionのtextが空でないことを確認して使う
    func rgstQ(){
        let realm = try! Realm()
        do{
            try realm.write {
                let book = realm.object(ofType: Book.self, forPrimaryKey: theBook.ISBN)
                let question = Question()
                for answer in answers{
                    let answerObject = Answer()
                    answerObject.answerID = returnTimestamp()
                    answerObject.answerStr = answer
                    realm.add(answerObject)
                    question.answers.append(answerObject)
                }
                question.questionID = returnTimestamp()
                question.questionStr = questionTextField.text!
                question.registeredDay = Date()
                question.nextEmergenceDay = return_yyyyMMdd(date: Date(timeInterval: 60*60*24, since: Date()))
                book?.questions.append(question)
                realm.add(question)
            }
        }catch let error{
            print(error)
        }
    }
    
    func returnTimestamp()->String{
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyyMMddHHmmssSSSS"
        let str = formatter.string(from: now)
        return str
    }
    func return_yyyyMMdd(date: Date)->String{
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyyMMdd"
        let str = formatter.string(from: date)
        return str
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

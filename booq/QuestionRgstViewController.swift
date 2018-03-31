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
    @IBOutlet var questionTextField: UITextView!
    @IBOutlet var answerTextField: UITextView!
    @IBOutlet var bookTitleLabel: UILabel!
    var theBook: Book!
    var question = ""
    var answers:[String] = []
    var from = ""
    
    @IBAction func tapScreen(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBOutlet var navigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: theBook.imageLink)
        let data = try? Data(contentsOf: url!)
        var image = UIImage()
        if data != nil{
            image = UIImage(data:data!)!
        }else{
            //端末に保存されている画像を表示&Labelでタイトルを表示
        }
        bookImageView.image  = image
        bookTitleLabel.text = theBook.title
                
        //キーボードを閉じる
        // 仮のサイズでツールバー生成
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(QuestionRgstViewController.commitButtonTapped))
        kbToolBar.items = [spacer, commitButton]
        questionTextField.inputAccessoryView = kbToolBar
        answerTextField.inputAccessoryView = kbToolBar
    }
    
    @objc func commitButtonTapped (){
        self.view.endEditing(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            if tag == 1 {
                self.view.endEditing(true)
            }
        }
    }
    
    
    @IBAction func pushedPeke(_ sender: Any) {
        back()
    }
    
    func back(){
        switch from {
        case "PopUpView":
            performSegue(withIdentifier: "RgstEnd", sender: nil)
            break
        case "BookQuestionView":
            performSegue(withIdentifier: "seeQuestion", sender: theBook)
            break
        default:
            break
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPushRgstAndCntnue(_ sender: Any) {
        pushRgst()
    }
    
    @IBAction func didPushRgstAndEnd(_ sender: Any) {
        pushRgst()
        back()
    }
    
    
    
    //answersに空白以外のtextfieldのtextを代入して、questionのtextが空でないことを確認して使う
    func rgstQ(){
        let realm = try! Realm()
        do{
            try realm.write {
                let book = realm.object(ofType: Book.self, forPrimaryKey: theBook.ISBN)
                let question = Question()
                var i = 0
                for answer in answers{
                    let answerObject = Answer()
                    answerObject.answerID = returnTimestamp() + String(i)
                    i = i + 1
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
    
    func pushRgst(){
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "seeQuestion"?:
            let destination = segue.destination as! BookQestionViewController
            destination.theBook = sender as! Book
            break
        default:
            break
        }
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

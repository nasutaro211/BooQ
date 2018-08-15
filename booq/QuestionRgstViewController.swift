//
//  QuestionRgstViewController.swift
//  booq
//
//  Created by 中田　優樹 on 2018/03/21.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import RealmSwift
import Flurry_iOS_SDK
import SDWebImage


class QuestionRgstViewController: UIViewController,UITextViewDelegate,UIScrollViewDelegate{
    @IBOutlet var bookImageView: UIImageView!
    @IBOutlet var questionTextField: UITextView!
    @IBOutlet var answerTextField: UITextView!
    @IBOutlet var bookTitleLabel: UILabel!
    @IBOutlet var logLable: PaddingLabel!
    
    var theBook: Book!
    var question = ""
    var answers:[String] = []
    var from = ""
    var txtActiveView = UITextView()
    @IBOutlet var scrollView: UIScrollView!
    var scrollViewHeight : CGFloat = 0

    
    //キーボード以外タッチしたらキーボード消える
    @IBAction func tapScreen(_ sender: Any) {
        self.view.endEditing(true)
    }
    //いつもの
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        questionTextField.delegate = self
        answerTextField.delegate = self
        bookImageView.setImage(of: theBook)
        bookTitleLabel.text = theBook.title
        logLable.isHidden = true
        logLable.alpha = 0
        //scrollViewの高さ保持
        scrollViewHeight = scrollView.frame.size.height

        
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
    //完了ボタンが押された時
    @objc func commitButtonTapped (){
        self.view.endEditing(true)
    }
    //おそらくいらない
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            if tag == 1 {
                self.view.endEditing(true)
            }
        }
    }
    //キーボードに隠れなくするべきtextViewを代入
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        txtActiveView = textView
        return true
    }
    //???キーボードに隠れなくする系
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(QuestionRgstViewController.handleKeyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(QuestionRgstViewController.handleKeyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardWillShowNotification(_ notification: Notification){
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        let txtLimit = txtActiveView.frame.origin.y + txtActiveView.frame.height + 120
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        
        if txtLimit >= kbdLimit {
            scrollView.contentOffset.y = txtLimit - kbdLimit
        }
        //スクロールできるようにするため
        let keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        UIView.animate(withDuration: 0.4, animations: {
            self.scrollView.frame.size.height = self.scrollViewHeight - keyboard.height
        })
    }
    
    //正規表現
    func checkEmpty(string: String) -> Bool {
        let pattern = ".+"
        guard let regex = try? NSRegularExpression(pattern: pattern,
                                                   options: NSRegularExpression.Options()) else {
                                                    return false
        }
        
        return regex.numberOfMatches(in: string,
                                     options: NSRegularExpression.MatchingOptions(),
                                     range: NSRange(location: 0, length: string.count)) > 0
    }
    
    @objc func handleKeyboardWillHideNotification(_ notification: Notification) {
        //スクロールできるようにするため
        UIView.animate(withDuration: 0.4, animations: {
            self.scrollView.frame.size.height = self.view.frame.height
        })
        scrollView.contentOffset.y = 0
    }
    
    
    
    @IBAction func pushedPeke(_ sender: Any) {
        back()
    }
    
    func back(){
        switch from {
        case "PopUpView":
            performSegue(withIdentifier: "seeQuestion", sender: theBook)
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
        let button = sender as! UIButton
        button.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            button.isEnabled = true
        })
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
                question.numInBook = returnTimestamp()
                question.questionStr = questionTextField.text!
                question.registeredDay = Date()
                question.nextEmergenceDay = return_yyyyMMdd(date: Date(timeInterval: 60*60*24, since: Date()))
                book?.questions.append(question)
                realm.add(question)
            }
        }catch let error{
            print(error)
        }
        answers = []
        Flurry.logEvent("rgstQCalled")
    }
    
    func returnTimestamp()->String{
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyyMMddHHmmssSSSS"
        let str = formatter.string(from: now)
        return str
    }
    func return_yyyyMMdd(date: Date)->Int{
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyyMMdd"
        let str = formatter.string(from: date)
        return Int(str)!
    }
    
    func pushRgst(){
        if checkEmpty(string: questionTextField.text!) && checkEmpty(string: answerTextField.text) {
            //どちらも埋まっている時
            answers.append(answerTextField.text)
            rgstQ()
            logStr()
        }else{
            //ログ表示
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
    
    //LogViewを表示
    func logStr(){
        self.logLable.alpha = 0
        logLable.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {
            self.logLable.alpha = 1
        }, completion:{
            (value: Bool) in
            
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            self.answerTextField.text = ""
            self.questionTextField.text = ""
            UIView.animate(withDuration: 0.4, animations: {
                self.logLable.alpha = 0
            }, completion:  {
                (value: Bool) in
                self.logLable.isHidden = true
            })
        })
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



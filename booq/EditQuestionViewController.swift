//
//  EditQuestionViewController.swift
//  booq
//
//  Created by 中田　優樹 on 2018/04/02.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import RealmSwift

class EditQuestionViewController: UIViewController ,UITextViewDelegate,UIScrollViewDelegate{
    @IBOutlet var bookTitleLabel: UILabel!
    @IBOutlet var questionTextView: UITextView!
    @IBOutlet var answerTextView: UITextView!
    @IBOutlet var bookImageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    var txtActiveView = UITextView()
    var theQuestion:Question!
    var from = ""
    var scrollViewHeight : CGFloat = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //viewを作る
        questionTextView.text = theQuestion.questionStr
        answerTextView.text = theQuestion.answers[0].answerStr
        bookImageView.sd_setImage(with: URL(string:(theQuestion.books.first?.imageLink)!), completed: nil)
        if bookImageView.image == nil && theQuestion.books.first?.imageData != nil{
            bookImageView.image = UIImage(data: (theQuestion.books.first?.imageData!)!)
        }
        
        bookTitleLabel.text = theQuestion.books.first!.title
        
        //tableviewのdelegate
        questionTextView.delegate = self
        answerTextView.delegate = self
        scrollView.delegate = self
        // 初期状態の高さを保存-!
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
        questionTextView.inputAccessoryView = kbToolBar
        answerTextView.inputAccessoryView = kbToolBar
    }
    //KeyBoard閉じる
    @objc func commitButtonTapped (){
        self.view.endEditing(true)
    }
    //編集完了したとき
    @IBAction func endEditting(_ sender: Any) {
        let realm = try! Realm()
        try! realm.write {
            theQuestion.questionStr = questionTextView.text
            theQuestion.answers[0].answerStr = answerTextView.text
            realm.add(theQuestion, update: true)
        }
        switch from {
        case "BookQuestionViewController":
            performSegue(withIdentifier: "toBookQuestionView", sender: nil)
            break
        case "SecondViewController":
            performSegue(withIdentifier: "backToAllQuestionView", sender: nil)
            break
        default:
            break
        }
    }
    
    //キーボード以外をタップしたときキーボードを隠す
    @IBAction func tapView(_ sender: Any) {
        self.view.endEditing(true)
    }

    //prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "backToAllQuestionView":
            let destination = segue.destination as! TabBarController
            destination.willAppear = 1
            return
        case "toBookQuestionView":
            let destination = segue.destination as! BookQestionViewController
            destination.theBook = theQuestion.books.first
            return
        default:
            return
        }
    }

    
    //
    @IBAction func pushPeke(_ sender: Any) {
        switch from {
        case "BookQuestionViewController":
            performSegue(withIdentifier: "toBookQuestionView", sender: nil)
            break
        case "SecondViewController":
            performSegue(withIdentifier: "backToAllQuestionView", sender: nil)
            break
        default:
            break
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
    @objc func handleKeyboardWillShowNotification(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        let txtLimit = txtActiveView.frame.origin.y + txtActiveView.frame.height + 120
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        if txtLimit >= kbdLimit {
            scrollView.contentOffset.y = txtLimit - kbdLimit
        }
        let keyboard = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue)!
        
        // 外枠のサイズを初期の外枠サイズからキーボードサイズ分ひくよー
        UIView.animate(withDuration: 0.4, animations: {
            self.scrollView.frame.size.height = self.scrollViewHeight - keyboard.height
            
        })
    }
    @objc func handleKeyboardWillHideNotification(_ notification: Notification) {
        scrollView.contentOffset.y = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.scrollView.frame.size.height = self.view.frame.height
        })
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

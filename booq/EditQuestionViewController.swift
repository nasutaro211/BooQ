//
//  EditQuestionViewController.swift
//  booq
//
//  Created by 中田　優樹 on 2018/04/02.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import RealmSwift

class EditQuestionViewController: UIViewController {
    var theQuestion:Question!
    
    @IBAction func tapView(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    @IBOutlet var bookTitleLabel: UILabel!
    @IBOutlet var questionTextView: UITextView!
    @IBOutlet var answerTextView: UITextView!
    @IBOutlet var bookImageView: UIImageView!
    var txtActiveView = UITextView()
    
    @IBOutlet var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionTextView.text = theQuestion.questionStr
        answerTextView.text = theQuestion.answers[0].answerStr
        bookImageView.sd_setImage(with: URL(string:(theQuestion.books.first?.imageLink)!), completed: nil)
        bookTitleLabel.text = theQuestion.books.first!.title
        
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

        // Do any additional setup after loading the view.
    }
    
    @objc func commitButtonTapped (){
        self.view.endEditing(true)
    }
    
    @IBAction func endEditting(_ sender: Any) {
        let realm = try! Realm()
        try! realm.write {
            theQuestion.questionStr = questionTextView.text
            theQuestion.answers[0].answerStr = answerTextView.text
            realm.add(theQuestion, update: true)
        }
        performSegue(withIdentifier: "backToAllQuestionView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "backToAllQuestionView":
            let destination = segue.destination as! TabBarController
            destination.willAppear = 1
            return
        default:
            return
        }
    }
    
    @IBAction func pushPeke(_ sender: Any) {
        performSegue(withIdentifier: "backToAllQuestionView", sender: nil)
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
        var txtLimit = txtActiveView.frame.origin.y + txtActiveView.frame.height + 120
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        
        if txtLimit >= kbdLimit {
            scrollView.contentOffset.y = txtLimit - kbdLimit
        }
    }
    @objc func handleKeyboardWillHideNotification(_ notification: Notification) {
        scrollView.contentOffset.y = 0
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

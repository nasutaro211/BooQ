//
//  DeletePopUpViewController.swift
//  booq
//
//  Created by 中田　優樹 on 2018/04/02.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import SDWebImage
import RealmSwift

class DeletePopUpViewController: UIViewController {
    
    var theQuestion:Question!

    @IBOutlet var answerLabel: UILabel!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var bookImageView: UIImageView!
    var from = ""
    //いつもの
    override func viewDidLoad() {
        super.viewDidLoad()
        answerLabel.text = theQuestion.answers[0].answerStr
        questionLabel.text = theQuestion.questionStr
        bookImageView.sd_setImage(with: URL(string: (theQuestion.books.first?.imageLink)!), completed: nil)
        
    }
    
    //問題を編集する
    @IBAction func editQuestion(_ sender: Any) {
        performSegue(withIdentifier: "toEditQuestionView", sender: theQuestion)
    }
    //問題を消す
    @IBAction func deleteQuestion(_ sender: Any) {
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "問題の削除", message: "この問題を削除してもいいですか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertActionStyle.destructive, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.deleteQ()
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }

    func deleteQ(){
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self.theQuestion)
        }
        //前の画面を所得してreload
        switch from {
        case "BookQuestionViewController":
            (self.presentingViewController!  as! BookQestionViewController).tableView.reloadData()
            break
        case "SecondViewController":
            ((self.presentingViewController! as! UINavigationController).viewControllers[0] as! SecondViewController).tableView.reloadData()
            break
        default:
            break
        }
        dismiss(animated: true, completion: nil)
    }
    //viewを閉じる
    @IBAction func didPushPeke(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toEditQuestionView":
            let destination = segue.destination as! EditQuestionViewController
            destination.theQuestion = sender as! Question
            destination.from = from
            break
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //他のところ押したら閉じる処理
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            if tag == 1 {
                dismiss(animated: true, completion: nil)
            }
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

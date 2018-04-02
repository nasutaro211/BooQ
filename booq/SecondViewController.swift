//
//  SecondViewController.swift
//  booq
//
//  Created by 中田　優樹 on 2018/03/15.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK
import RealmSwift

class SecondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet var alertLave: UILabel!
    @IBOutlet var tableView: UITableView!
    var questions: Results<Question>!
    

    //いつもの１
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if questions.count != 0
        {alertLave.isHidden = true}
        return questions.count
    }
    //いつもの２
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllQuestionCell", for: indexPath) as! QuestionTableViewCell
        cell.questionLabel.text = questions[indexPath.row].questionStr
        cell.bookImageView.sd_setImage(with: URL(string: questions[indexPath.row].books.first!.imageLink), completed: nil)
        cell.showAnswerButton.tag = indexPath.row
        return cell
    }
    //いつもの０
    override func viewDidLoad() {
        super.viewDidLoad()
        //qeustionsをとる
        let realm = try! Realm()
        questions = realm.objects(Question.self)
        //tableviewのデータとcellの大きさ
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20
        tableView.isEditing = false
        //EditButton生成
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.title = "問題一覧"
        // UILongPressGestureRecognizer宣言
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.cellLongPressed(recognizer:)))//Selector(("cellLongPressed:")))
        longPressRecognizer.delegate = self
        tableView.addGestureRecognizer(longPressRecognizer)
        //Flurry
        Flurry.logEvent("seeAllQuestions")
    }
    //消して戻った時用
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @objc func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        
        // 押された位置でcellのPathを取得
        let point = recognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        if indexPath == nil {
            
        } else if recognizer.state == UIGestureRecognizerState.began  {
            // 長押しされた場合の処理
            performSegue(withIdentifier: "toDeleteQuestionView", sender: questions[(indexPath?.row)!])
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toDeleteQuestionView":
            let destination = segue.destination as! DeletePopUpViewController
            destination.theQuestion = sender as! Question
            destination.from = "SecondViewController"
        default:
            return
        }
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        let deleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "削除") { (action, index) -> Void in
//            let realm = try! Realm()
//            try! realm.write {
//                realm.delete(self.questions[indexPath.row])
//            }
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//        deleteButton.backgroundColor = UIColor.red
//        
//        return [deleteButton]
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self.questions[indexPath.row])
        }
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


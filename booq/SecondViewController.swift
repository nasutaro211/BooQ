//
//  SecondViewController.swift
//  booq
//
//  Created by 中田　優樹 on 2018/03/15.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import RealmSwift

class SecondViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate {
    
    @IBOutlet var alertLave: UILabel!
    @IBOutlet var tableView: UITableView!
    var questions: Results<Question>!
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if questions.count != 0
        {alertLave.isHidden = true}
        return questions.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllQuestionCell", for: indexPath) as! QuestionTableViewCell
        cell.questionLabel.text = questions[indexPath.row].questionStr
        cell.bookImageView.sd_setImage(with: URL(string: questions[indexPath.row].books.first!.imageLink), completed: nil)
        cell.showAnswerButton.tag = indexPath.row
        return cell
    }
    
    
    

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
        //EditButton生成
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.title = "問題一覧"
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        //override前の処理を継続してさせる
        super.setEditing(editing, animated: animated)
        //tableViewの編集モードを切り替える
        tableView.isEditing = editing
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


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

class SecondViewController: UIViewController,UITabBarControllerDelegate,UIGestureRecognizerDelegate {
    //IBOutlet
    @IBOutlet var alertLave: UILabel!
    @IBOutlet var tableView: UITableView!
    //question一覧
    var questions: Results<Question>!
    

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
        tableView.estimatedRowHeight = 50
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
            performSegue(withIdentifier: "toDeleteQuestionView", sender: questions[questions.count - (indexPath?.row)! - 1])
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
    
    @IBAction func showAnswer(_ sender: Any) {
        //答えの表示からファイト！多分tagの番号のセルをとってなんとかするのが一番よ
        let button = sender as! UIButton
        let indexPath = IndexPath(row: button.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! QuestionTableViewCell
        if cell.answerTextView.text == "答え ▼"{
            cell.answerTextView.text = "答え ▶︎ " + questions[questions.count - indexPath.row - 1].answers[0].answerStr
            //cellの高さをUpdaete
            tableView.beginUpdates()
            tableView.endUpdates()
            //Flurry用
            let param = ["book":questions[questions.count - indexPath.row - 1].books.first!.title,"Question":questions[questions.count - indexPath.row - 1].questionStr,"Answer":questions[questions.count - indexPath.row - 1].answers[0].answerStr]
            Flurry.logEvent("showAnAnswer",withParameters: param)
        }else{
            cell.answerTextView.text = "答え ▼"
            tableView.beginUpdates()
            tableView.endUpdates()
        }
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension SecondViewController:UITableViewDelegate,UITableViewDataSource{
    //数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if questions.count != 0
        {alertLave.isHidden = true}
        return questions.count
    }
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllQuestionCell", for: indexPath) as! QuestionTableViewCell
        let question = questions[questions.count - indexPath.row - 1]
        cell.questionLabel.text = question.questionStr
        cell.bookImageView.sd_setImage(with: URL(string: question.books.first!.imageLink), completed: nil)
        cell.showAnswerButton.tag = indexPath.row
        cell.selectionStyle = .gray
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


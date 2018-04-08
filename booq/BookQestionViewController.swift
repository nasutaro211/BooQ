//
//  BookQestionViewController.swift
//  booq
//
//  Created by 中田　優樹 on 2018/03/24.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK
import RealmSwift
import SDWebImage

class BookQestionViewController: UIViewController,UIGestureRecognizerDelegate{
    @IBOutlet var tableView: UITableView!
    @IBOutlet var alertLabel: UILabel!
    var questions: List<Question>!
    var theBook: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questions = theBook.questions
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20
        // UILongPressGestureRecognizer宣言
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.cellLongPressed(recognizer:)))//Selector(("cellLongPressed:")))
        longPressRecognizer.delegate = self
        tableView.addGestureRecognizer(longPressRecognizer)
    }
    
    @IBAction func toQuestionRgstVIew(_ sender: Any) {
        performSegue(withIdentifier: "AddQuestion", sender: theBook)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "AddQuestion"?:
            let questionRgstView = segue.destination as! QuestionRgstViewController
            questionRgstView.theBook = sender as! Book
            questionRgstView.from = "BookQuestionView"
            break
        case "toDeleteQuestionView":
            let destination = segue.destination as! DeletePopUpViewController
            destination.theQuestion = sender as! Question
            destination.from = "BookQuestionViewController"
        default:
            break
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    
    @IBAction func showAnswer(_ sender: Any) {
        //答えの表示からファイト！多分tagの番号のセルをとってなんとかするのが一番よ
        let button = sender as! UIButton
        let indexPath = IndexPath(row: button.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! BookQuestionTableViewCell
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
}


extension BookQestionViewController:UITableViewDataSource,UITableViewDelegate{
    //数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if questions.count != 0 {alertLabel.isHidden = true}
        return questions.count
    }
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookQuestionCell", for: indexPath) as! BookQuestionTableViewCell
        let question = questions[questions.count - indexPath.row - 1]
        cell.questionLabel.text = question.questionStr
        let url = URL(string: question.books.first!.imageLink)
        cell.bookImageView.sd_setImage(with: url!, completed: nil)
        if cell.bookImageView.image == nil && question.books.first!.imageData != nil{
            cell.bookImageView.image = UIImage(data: question.books.first!.imageData!)
        }
        cell.showAnswerButton.tag = indexPath.row
        return cell
    }

}

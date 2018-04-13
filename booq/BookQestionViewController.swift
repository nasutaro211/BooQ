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
    var questions: Results<Question>!
    var theBook: Book!
    @IBOutlet var nvbar: UINavigationBar!
    var from = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questions = theBook.questions.sorted(byKeyPath: "numInBook", ascending: false)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20
        nvbar.items![0].title = theBook.title
        // UILongPressGestureRecognizer宣言
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.cellLongPressed(recognizer:)))//Selector(("cellLongPressed:")))
        longPressRecognizer.delegate = self
        tableView.addGestureRecognizer(longPressRecognizer)
        //編集ボタン追加
//        let item = nvbar.items![0]
//        item.rightBarButtonItems?.remove(at: 0)
//        let button = editButtonItem
//        button.tintColor = UIColor(displayP3Red: 235/250, green: 235/250, blue: 235/250, alpha: 1)
//        item.rightBarButtonItems?.append(button)
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
    
    
    @IBAction func showAnswer(_ sender: Any) {
        //答えの表示からファイト！多分tagの番号のセルをとってなんとかするのが一番よ
        let button = sender as! UIButton
        let indexPath = IndexPath(row: button.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! BookQuestionTableViewCell
        if cell.answerTextView.text == "答え ▼"{
            cell.answerTextView.text = "答え ▶︎ " + questions[indexPath.row].answers[0].answerStr
            //cellの高さをUpdaete
            tableView.beginUpdates()
            tableView.endUpdates()
            //Flurry用
            let param = ["book":questions[indexPath.row].books.first!.title,"Question":questions[indexPath.row].questionStr,"Answer":questions[indexPath.row].answers[0].answerStr]
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
        let question = questions[indexPath.row]
        cell.questionLabel.text = question.questionStr
        cell.bookImageView.sd_setImage(with: URL(string: question.books.first!.imageLink), completed: nil)
        if cell.bookImageView.image == nil && question.books.first!.imageData != nil{
            cell.bookImageView.image = UIImage(data: question.books.first!.imageData!)
        }
        cell.showAnswerButton.tag = indexPath.row
        cell.selectionStyle = .gray
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //並び替えられるセルの番号を指定。今回は全て
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}

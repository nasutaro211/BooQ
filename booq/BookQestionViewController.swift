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

class BookQestionViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate{
    @IBOutlet var tableView: UITableView!
    var questions: List<Question>!
    var theBook: Book!

    @IBOutlet var alertLabel: UILabel!
    
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if questions.count != 0 {alertLabel.isHidden = true}
        return questions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookQuestionCell", for: indexPath) as! BookQuestionTableViewCell
        cell.questionLabel.text = questions[indexPath.row].questionStr
        let url = URL(string: questions[indexPath.row].books.first!.imageLink)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        cell.bookImageView.image = image
        cell.showAnswerButton.tag = indexPath.row
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
            let param = ["book":questions[indexPath.row].books.first!.title,"Question":questions[indexPath.row].questionStr,"Answer":questions[indexPath.row].answers[0].answerStr]
            Flurry.logEvent("showAnAnswer",withParameters: param)
        }else{
            cell.answerTextView.text = "答え ▼"
            tableView.beginUpdates()
            tableView.endUpdates()
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

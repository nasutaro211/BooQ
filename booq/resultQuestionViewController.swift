//
//  resultQuestionViewController.swift
//  booq
//
//  Created by 梶原大進 on 2018/05/28.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import RealmSwift

class resultQuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var questions: Results<Question>!
    var randomNumbers: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.isEditing = false
        
        //qeustionsをとる
        let realm = try! Realm()
        questions = realm.objects(Question.self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showAnswer(_ sender: Any) {
        let button = sender as! UIButton
        let indexPath = IndexPath(row: button.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! QuestionTableViewCell
        if cell.answerTextView.text == "答え ▼"{
            cell.answerTextView.text = "答え ▶︎ " + questions[randomNumbers[indexPath.row]].answers[0].answerStr
            //cellの高さをUpdaete
            tableView.beginUpdates()
            tableView.endUpdates()
        }else{
            cell.answerTextView.text = "答え ▼"
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    @IBAction func endBtnAc() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return randomNumbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllQuestionCell", for: indexPath) as! QuestionTableViewCell
        cell.showAnswerButton.tag = indexPath.row
        cell.selectionStyle = .gray
        let question = questions[randomNumbers[indexPath.row]]
        cell.questionLabel.text = question.questionStr
        cell.bookImageView.setImage(of: question.books.first!)
        return cell
    }

}

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
    //追加
    var questions_new: [String] = []
    var answers: [String] = []
    var images: [Book] = []
    
    var randomNumbers: [Int] = []
    var subscripts: [Int] = []
    var flag: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
        tableView.isEditing = false
        
        switch flag {
        case "RandomQuestion":
            for i in 0..<questions.count {
                questions_new.append(questions[randomNumbers[i]].questionStr)
                answers.append(questions[randomNumbers[i]].answers[0].answerStr)
                images.append(questions[randomNumbers[i]].books.first!)
            }
        case "TodayCheck":
            for i in 0..<questions_new.count {
                subscripts.append(randomNumbers[i])
            }
        case "EachQuestion":
            for i in 0..<questions.count {
                randomNumbers.append(i)
                questions_new.append(questions[i].questionStr)
                answers.append(questions[i].answers[0].answerStr)
                images.append(questions[i].books.first!)
            }
        default:
            break
        }
        print(questions_new)
        print(answers)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showAnswer(_ sender: Any) {
        let button = sender as! UIButton
        let indexPath = IndexPath(row: button.tag, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! QuestionTableViewCell
        if cell.answerTextView.text == "答え ▼"{
            cell.answerTextView.text = "答え ▶︎ " + answers[randomNumbers[indexPath.row]]
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
        switch flag {
        case "RandomQuestion":
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        case "EachQuestion":
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        default:
            break
        }
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions_new.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllQuestionCell", for: indexPath) as! QuestionTableViewCell
        cell.showAnswerButton.tag = indexPath.row
        cell.selectionStyle = .gray
        cell.questionLabel.text = questions_new[randomNumbers[indexPath.row]]
        cell.bookImageView.setImage(of: images[randomNumbers[indexPath.row]])
        return cell
    }

}

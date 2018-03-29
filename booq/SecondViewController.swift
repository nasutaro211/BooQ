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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let destination = viewController as? SecondViewController {
                destination.tableView.reloadData()
        }
    }

    
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
        
        let realm = try! Realm()
        questions = realm.objects(Question.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


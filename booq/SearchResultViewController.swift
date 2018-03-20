//
//  SearchResultViewController.swift
//  booq
//
//  Created by 中田　優樹 on 2018/03/20.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import RealmSwift

class SearchResultViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBAction func didPushRegistrationButton(_ sender: Any) {
        let button = sender as! UIButton
        let realm = try! Realm()
        let book = Book()
        book.ISBN = books[button.tag].isbn!
        if let imageLinks = books[button.tag].imageLinks, let imageLink = imageLinks["thumbnail"]{
            book.imageLink = imageLink
        }
        try! realm.write {
            realm.add(book)
        }
        performSegue(withIdentifier: "returnTabBar", sender: nil)
    }
    
    
    
    var books:[VolumeInfo] = []
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell") as! ResultableViewCell
        cell.titleLabel.text = books[indexPath.row].title
        cell.registrationButton.tag = indexPath.row
        return cell
    }
    
    @IBOutlet var resultTableView: UITableView!
    
    override func viewDidLoad() {
        resultTableView.delegate = self
        resultTableView.dataSource = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
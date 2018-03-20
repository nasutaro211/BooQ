//
//  FirstViewController.swift
//  booq
//
//  Created by 中田　優樹 on 2018/03/15.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class FirstViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet var booksCollectionView: UICollectionView!
    @IBOutlet var nothingBooksAlertLabel: UILabel!
    let realm = try! Realm()

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let books = realm.objects(Book.self)
        if (books.count != 0){
            nothingBooksAlertLabel.isHidden = true
        }
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let books = realm.objects(Book.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath) as! BooksCollectionViewCell
        cell.isbnLabel.text = books[indexPath.row].ISBN
        return cell
    }
    
    

    override func viewDidLoad() {
        booksCollectionView.delegate = self
        booksCollectionView.dataSource = self
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


//
//  EachBookQustionViewController.swift
//  booq
//
//  Created by 梶原大進 on 2018/05/29.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import RealmSwift

class EachBookQustionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var booksCollectionView: UICollectionView!
    @IBOutlet var nothingBooksAlertLabel: UILabel!
    
    var book: Book!
    var books: Results<Book>!
    
    var margin = CGFloat(10)
    var contentSize = CGFloat(50)
    
    var checkBool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        booksCollectionView.delegate = self
        booksCollectionView.dataSource = self
        
        let width = UIScreen.main.bounds.size.width
        margin = width/18
        contentSize = (width-4*margin)/7
        
        let realm = try! Realm()
        books = realm.objects(Book.self)
        
        if books.count != 0 {
            nothingBooksAlertLabel.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (books.count != 0){
            nothingBooksAlertLabel.isHidden = true
        }
        return books.count
    }
    //cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath) as! BooksCollectionViewCell
        cell.bookImageView.setImage(of: books[books.count - indexPath.row - 1])
        cell.pekeButton.tag = indexPath.row
        if checkBool == true {
            cell.pekeButton.alpha = 1
        } else {
            cell.pekeButton.alpha = 0
        }
        
        return cell
    }
    //押されたとき
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("押されたで")
        if checkBool == true {
            checkBool = false
            book = nil
        } else {
            checkBool = true
            book = books[books.count - indexPath.row - 1]
        }
        booksCollectionView.reloadData()
    }
    //cellの編集の可否
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    //コンテンツサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: contentSize*2, height: contentSize*3)
    }
    //枠との差
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }
    //二列になった時の縦との距離
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    //横のitem同士の距離
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }
    
    @IBAction func toQuestionAc() {
        if book != nil {
            let segue = storyboard?.instantiateViewController(withIdentifier: "EachQuestion") as! EachQuestionViewController
            segue.theBook = book
            self.present(segue, animated: true, completion: nil)
        }
    }
    
}

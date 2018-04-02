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
import SDWebImage


//var imageDictionary:Dictionary<String,UIImageView> = Dictionary<String,UIImageView>()

class FirstViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITabBarControllerDelegate,UITabBarDelegate {
    
    @IBOutlet var rgstButton: RoundedButtonm!
    @IBOutlet var booksCollectionView: UICollectionView!
    @IBOutlet var nothingBooksAlertLabel: UILabel!
    var books: Results<Book>!
    var canEditCollectionView = false
    var margin = CGFloat(10)//viewDidLoadで端末のviewサイズに合わせて動的に変える
    var contentSize = CGFloat(50)//viewDidLoadで端末のviewサイズに合わせて動的に変える,too.

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (books.count != 0){
            nothingBooksAlertLabel.isHidden = true
        }
        return books.count
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        let button = sender as! UIButton
        let realm = try! Realm()
        var deletedBook = realm.object(ofType: Book.self, forPrimaryKey: books[button.tag].ISBN)
        var deletedQuestions = deletedBook?.questions
        var deletedAnswers:[List<Answer>] = []
        for question in deletedQuestions!{
            deletedAnswers.append(question.answers)
        }
        try! realm.write {
            for a in deletedAnswers{
                realm.delete(a)
            }
            realm.delete(deletedBook!.questions)
            realm.delete(deletedBook!)
     }
        booksCollectionView.reloadData()
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath) as! BooksCollectionViewCell
        cell.bookImageView.sd_setImage(with: URL(string: books[indexPath.row].imageLink), completed: nil)
        cell.pekeButton.tag = indexPath.row
        if canEditCollectionView {
            cell.pekeButton.isHidden = false
        }else{
            cell.pekeButton.isHidden = true
        }
        return cell
    }
    

    
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "modal", sender: books[indexPath.row])
    }
    
    @IBAction func editButton(_ sender: Any) {
        canEditCollectionView = !canEditCollectionView
        booksCollectionView.reloadData()
    }
    

    override func viewDidLoad() {
        booksCollectionView.delegate = self
        booksCollectionView.dataSource = self
        
        //初期化のための下三行
//        if let fileURL = Realm.Configuration.defaultConfiguration.fileURL {
//            try! FileManager.default.removeItem(at: fileURL)
//        }
        //dafault.realmの確認
        let realm = try! Realm()
        books = realm.objects(Book.self)
        
        
        //collectionCIewLayoutをいじる
        let width = UIScreen.main.bounds.size.width
        let higth = UIScreen.main.bounds.size.height
        margin = width/18
        contentSize = (width-4*margin)/7
        
        //ボタンの影をつける
        rgstButton.layer.masksToBounds = false
        rgstButton.layer.shadowColor = UIColor.black.cgColor
        rgstButton.layer.shadowOpacity = 0.5 // 透明度
        rgstButton.layer.shadowOffset = CGSize(width: 0, height: 5) // 距離
        rgstButton.layer.shadowRadius = 5 // ぼかし量
        
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "modal"{
            let book = sender as! Book
            let destination = segue.destination as! PopUpViewController
            destination.theBook = book
        }
    }
    
    func test(){

    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


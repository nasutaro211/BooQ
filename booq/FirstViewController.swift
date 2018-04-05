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

        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "本の削除", message: "この本と登録されている問題を全て削除しますか？", preferredStyle:  UIAlertControllerStyle.alert)
        
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertActionStyle.destructive, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.deleteB(tag: button.tag)
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    func deleteB(tag:Int){
        let realm = try! Realm()
        var deletedBook = realm.object(ofType: Book.self, forPrimaryKey: books[tag].ISBN)
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
    //押されたとき
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


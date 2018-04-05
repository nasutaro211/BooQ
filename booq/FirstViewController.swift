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

class FirstViewController: UIViewController,UITabBarControllerDelegate,UITabBarDelegate {
    //IBOutlet
    @IBOutlet var rgstButton: RoundedButtonm!
    @IBOutlet var booksCollectionView: UICollectionView!
    @IBOutlet var nothingBooksAlertLabel: UILabel!
    //本一覧を入れる
    var books: Results<Book>!
    //本の削除ボタンの表示非表示に使う
    var canEditCollectionView = false
    //collectionVievのレイアウト用。viewDidLoadで端末のviewサイズに合わせて動的に変える。
    var margin = CGFloat(10)
    var contentSize = CGFloat(50)
    


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
    }
    
    
    //deleteButtonを押したらalert表示
    @IBAction func deleteButton(_ sender: Any) {
        let button = sender as! UIButton
        // ① UIAlertControllerクラスのインスタンスを生成
        let alert: UIAlertController = UIAlertController(title: "本の削除", message: "この本と登録されている問題を全て削除しますか？", preferredStyle:  UIAlertControllerStyle.alert)
        // ② Actionの設定
        let defaultAction: UIAlertAction = UIAlertAction(title: "削除", style: UIAlertActionStyle.destructive, handler:{
            (action: UIAlertAction!) -> Void in
            self.deleteB(tag: button.tag)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    //本を消す
    func deleteB(tag:Int){
        let realm = try! Realm()
        //消すobjectたちを取る
        let deletedBook = realm.object(ofType: Book.self, forPrimaryKey: books[books.count - tag - 1].ISBN)
        let deletedQuestions = deletedBook?.questions
        var deletedAnswers:[List<Answer>] = []
        for question in deletedQuestions!{
            deletedAnswers.append(question.answers)
        }
        //子供から消す
        try! realm.write {
            for a in deletedAnswers{
                realm.delete(a)
            }
            realm.delete(deletedBook!.questions)
            realm.delete(deletedBook!)
        }
        //viewをアップデート
        booksCollectionView.reloadData()
    }
    //編集ボタンを押したら
    @IBAction func editButton(_ sender: Any) {
        canEditCollectionView = !canEditCollectionView
        //バツマークを表示させている
        booksCollectionView.reloadData()
    }
    //遷移前
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //collectionViewCellが押されたとき
        if segue.identifier == "modal"{
            let book = sender as! Book
            let destination = segue.destination as! PopUpViewController
            destination.theBook = book
        }
    }
    //？？？
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension FirstViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
        cell.bookImageView.sd_setImage(with: URL(string: books[books.count - indexPath.row - 1].imageLink), completed: nil)
        cell.pekeButton.tag = indexPath.row
        if canEditCollectionView {
            cell.pekeButton.isHidden = false
        }else{
            cell.pekeButton.isHidden = true
        }
        return cell
    }
    //押されたとき
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "modal", sender: books[books.count - indexPath.row - 1])
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
    
}


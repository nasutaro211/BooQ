//
//  SelfRgstBookViewController.swift
//  booq
//
//  Created by 中田　優樹 on 2018/04/08.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import RealmSwift
import Flurry_iOS_SDK

class SelfRgstBookViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var isbn:String!
    
    @IBOutlet var bookImageView: UIImageView!
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var alertLabel: PaddingLabel!
    
    //いつもの
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        alertLabel.isHidden = true
        guard realm.object(ofType: Book.self, forPrimaryKey: isbn) == nil else{
            //すでにあるって怒ってもどる
            //alertで警告(ok押したら一個戻る)
            let alert: UIAlertController = UIAlertController(title: "重複登録", message: "このバーコードの本はすでに登録されています", preferredStyle:  UIAlertControllerStyle.alert)
            let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{
                (action: UIAlertAction!) -> Void in
                //カメラロールから選択
                self.performSegue(withIdentifier: "returnRgstView", sender: nil)
            })
            alert.addAction(defaultAction)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {self.present(alert, animated: true, completion: nil)})
            return
        }
        bookImageView.sd_setImage(with: URL(string: "http://illustrain.com/img/work/2016/illustrain10-hon01.png"), completed: nil)
    }
    
    //本の画像を追加のviewを出す
    @IBAction func addBookImage(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "画像の選択", message: nil, preferredStyle:  UIAlertControllerStyle.actionSheet)
        let defaultAction: UIAlertAction = UIAlertAction(title: "カメラロールから選択", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            //カメラロールから選択
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let pickerView = UIImagePickerController()
                pickerView.sourceType = .photoLibrary
                pickerView.delegate = self
                self.present(pickerView, animated: true)
            }
            
        })
        let cameraAction: UIAlertAction = UIAlertAction(title: "写真を撮る", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            //写真を撮る
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let pickerView = UIImagePickerController()
                pickerView.sourceType = .camera
                pickerView.delegate = self
                self.present(pickerView, animated: true)
            }

        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        alert.addAction(cameraAction)
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func rgstBook(_ sender: Any) {
        let realm = try! Realm()
        do{
            try realm.write {
                let book = Book()
                //すでにあったら脱出(一応ここでも)
                guard realm.object(ofType: Book.self, forPrimaryKey: isbn) == nil else{
                    return
                }
                guard titleTextView.text != "" && titleTextView.text != nil else{
                    //titleなしはいかん
                    logStr()
                    return
                }
                book.ISBN = isbn
                book.title = titleTextView.text
                book.imageLink = ""
                book.imageData = UIImageJPEGRepresentation(bookImageView.image!, 1)//PNGRepresentation(bookImageView.image!)
                realm.add(book)
                Flurry.logEvent("AddOriginalBook")
                performSegue(withIdentifier: "returnTabBar", sender: nil)
            }
        }catch let error{
            print(error)
        }

        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // 選択した写真を取得する
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        // ビューに表示する
        self.bookImageView.image = image
        // 写真を選ぶビューを引っ込める
        self.dismiss(animated: true)
    }
    
    func logStr(){
        self.alertLabel.alpha = 0
        alertLabel.isHidden = false
        UIView.animate(withDuration: 0.4, animations: {
            self.alertLabel.alpha = 1
        }, completion:nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            UIView.animate(withDuration: 0.4, animations: {
                self.alertLabel.alpha = 0
            }, completion:  {
                (value: Bool) in
                self.alertLabel.isHidden = true
            })
        })
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

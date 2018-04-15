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

class SelfRgstBookViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UIScrollViewDelegate {
    var isbn:String!
    
    @IBOutlet var bookImageView: UIImageView!
    @IBOutlet var titleTextView: UITextView!
    @IBOutlet var alertLabel: PaddingLabel!
    var txtActiveView = UITextView()
    @IBOutlet var scrollView: UIScrollView!
    
    
    //いつもの
    override func viewDidLoad() {
        super.viewDidLoad()
        let realm = try! Realm()
        alertLabel.isHidden = true
        alertLabel.alpha = 0
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
        //キーボードを閉じる
        // 仮のサイズでツールバー生成
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(QuestionRgstViewController.commitButtonTapped))
        kbToolBar.items = [spacer, commitButton]
        titleTextView.inputAccessoryView = kbToolBar
        //delegate関係
        scrollView.delegate = self
        titleTextView.delegate = self
    }
    
    //完了ボタンが押された時
    @objc func commitButtonTapped (){
        self.view.endEditing(true)
    }
    //キーボード以外タッチしたらキーボード消える
    @IBAction func didTouchOutsideofTextView(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    
    //???キーボードに隠れなくする系
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(QuestionRgstViewController.handleKeyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(QuestionRgstViewController.handleKeyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        txtActiveView = textView
        return true
    }
    
    @objc func handleKeyboardWillShowNotification(_ notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let myBoundSize: CGSize = UIScreen.main.bounds.size
        var txtLimit = txtActiveView.frame.origin.y + txtActiveView.frame.height + 120
        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
        
        if txtLimit >= kbdLimit {
            scrollView.contentOffset.y = txtLimit - kbdLimit
        }
    }
    
    @objc func handleKeyboardWillHideNotification(_ notification: Notification) {
        scrollView.contentOffset.y = 0
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
                book.imageFileURLStr = self.rgstToDocument(image: bookImageView.image!, as: isbn)
//                book.imageData = UIImageJPEGRepresentation(bookImageView.image!, 1)//PNGRepresentation(bookImageView.image!)
                realm.add(book)
                Flurry.logEvent("AddOriginalBook")
                performSegue(withIdentifier: "returnTabBar", sender: nil)
            }
        }catch let error{
            print(error)
        }
    }
    
    func rgstToDocument(image: UIImage,as fileName: String) -> String{
        let pngImageData = UIImagePNGRepresentation(image)
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        try! pngImageData!.write(to: fileURL)
        return fileURL.absoluteString
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

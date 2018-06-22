//
//  InquiryFormViewController.swift
//  booq
//
//  Created by 梶原大進 on 2018/06/22.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import Alamofire

class InquiryFormViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var inquiryTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //閉じるボタン追加
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default
        kbToolBar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let closeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(InquiryFormViewController.onClickCloseButton))
        kbToolBar.items = [spacer, closeButton]
        inquiryTextView.inputAccessoryView = kbToolBar
        
        inquiryTextView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func HttpRequest() {
        let url = "https://script.google.com/macros/s/AKfycbyx0B-PgEjBhwg3ZeN9dQxQuypdmPjKgFQNOnAZ8tEWnqPfAoA/exec"
        let headers: HTTPHeaders = [
            "Contenttype": "application/json"
        ]
        let parameters:[String: Any] = [
            "content": inquiryTextView.text
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            if let result = response.result.value as? [String: Any] {
                print(result)
            }
        }
    }
    
    override func  touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func onClickCloseButton() {
        inquiryTextView.resignFirstResponder()
    }
    
    @IBAction func sendInquiry() {
        HttpRequest()
        
        let alert: UIAlertController = UIAlertController(title: "", message: "送信しました", preferredStyle:  UIAlertControllerStyle.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }

}

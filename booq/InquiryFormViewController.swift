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
        
        //ビューを作成する。
        let testView = UIView()
        testView.frame.size.height = 60
        
        //「閉じるボタン」を作成する。
        let closeButton = UIButton(frame:CGRect(x: CGFloat(UIScreen.main.bounds.size.width)-70, y: 0, width: 70, height: 50))
        closeButton.setTitle("閉じる", for: .normal)
        closeButton.addTarget(self,action:Selector(("onClickCloseButton:")), for: .touchUpInside)
        testView.addSubview(closeButton)
        inquiryTextView.inputAccessoryView = testView
        
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
        
    }

}

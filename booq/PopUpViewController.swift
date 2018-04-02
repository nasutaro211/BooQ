//
//  PopUpViewController.swift
//  booq
//
//  Created by 中田　優樹 on 2018/03/21.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit
import Alamofire
import Flurry_iOS_SDK

class PopUpViewController: UIViewController {
    @IBOutlet var titleLabel: UILabel!
    var theBook:Book!
    @IBOutlet var authorLabel: UILabel!
    
    @IBOutlet var bookImageView: UIImageView!
    @IBAction func toQstnRgstView(_ sender: Any) {
        performSegue(withIdentifier: "toQstnRgstView", sender: theBook)
    }
    @IBAction func toBookQuestionView(_ sender: Any) {
        Flurry.logEvent("LookBookQuestion")
        performSegue(withIdentifier: "toBookQuestionView", sender: theBook)
    }
    @IBOutlet var titileLabel: UILabel!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //問題を登録
        if segue.identifier == "toQstnRgstView"{
            let destination = segue.destination as! QuestionRgstViewController
            destination.theBook = sender as! Book
            destination.from = "PopUpView"
        }
        //問題一覧
        if segue.identifier == "toBookQuestionView"{
            let destination = segue.destination as! BookQestionViewController
            destination.theBook = sender as! Book
        }
    }
    @IBOutlet var seeButton: RoundedButtonm!
    @IBOutlet var rgstButton: RoundedButtonm!
    override func viewDidLoad() {
        super.viewDidLoad()
        bookImageView.sd_setImage(with:URL(string: theBook.imageLink), completed: nil)
        titleLabel.text = theBook.title
        authorLabel.text = theBook.authors
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPushClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch: UITouch in touches {
            let tag = touch.view!.tag
            if tag == 1 {
                dismiss(animated: true, completion: nil)
            }
        }
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

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
        Flurry.logEvent("toQuestionRgstView")
        let tabBarController = self.presentingViewController as! TabBarController
        self.dismiss(animated: false, completion: {
            tabBarController.performSegue(withIdentifier: "toQstnRgstView", sender: self.theBook)
        })
    }
    @IBAction func toBookQuestionView(_ sender: Any) {
        let tabBarController = self.presentingViewController as! TabBarController
        self.dismiss(animated: false, completion: {
            Flurry.logEvent("LookBookQuestion")
            tabBarController.performSegue(withIdentifier: "toBookQuestionView", sender: self.theBook)
        })

    }
    @IBOutlet var titileLabel: UILabel!

    @IBOutlet var seeButton: RoundedButtonm!
    @IBOutlet var rgstButton: RoundedButtonm!
    override func viewDidLoad() {
        super.viewDidLoad()
        bookImageView.sd_setImage(with:URL(string: theBook.imageLink), completed: nil)
        if bookImageView.image == nil && theBook.imageData != nil{
            bookImageView.image = UIImage(data: theBook.imageData!)
        }
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

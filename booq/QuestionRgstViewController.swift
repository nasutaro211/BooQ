//
//  QuestionRgstViewController.swift
//  booq
//
//  Created by 中田　優樹 on 2018/03/21.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit

class QuestionRgstViewController: UIViewController {
    @IBOutlet var bookImageView: UIImageView!
    @IBOutlet var bookTitleLabel: UILabel!
    @IBOutlet var questionTextField: UITextView!
    @IBOutlet var answerTextField: UITextView!
    var theBook: Book!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: theBook.imageLink)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)
        bookImageView.image  = image
        
        bookTitleLabel.text = theBook.title

        // Do any additional setup after loading the view.
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

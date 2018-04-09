//
//  BookQuestionTableViewCell.swift
//  booq
//
//  Created by 中田　優樹 on 2018/03/24.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit

class BookQuestionTableViewCell: UITableViewCell {
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var bookImageView: UIImageView!
    @IBOutlet var showAnswerButton: UIButton!
    
    @IBOutlet var answerTextView: UITextView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor(red: 235/255, green: 225/255, blue: 213/255, alpha: 1.0)//[UIColor colorWithRed:.0 green:225/255.0 blue:.0 alpha:1.0]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

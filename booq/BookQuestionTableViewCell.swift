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
        self.backgroundColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

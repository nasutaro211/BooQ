//
//  BookQuestionTableViewCell.swift
//  booq
//
//  Created by 中田　優樹 on 2018/03/24.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit

class BookQuestionTableViewCell: UITableViewCell {
    @IBOutlet var bookImageView: UIImageView!
    @IBOutlet var showAnswerButton: UIButton!
    @IBOutlet var questionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
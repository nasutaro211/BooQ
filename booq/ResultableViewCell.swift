//
//  ResultableViewCell.swift
//  booq
//
//  Created by 中田　優樹 on 2018/03/20.
//  Copyright © 2018年 nakatayuki. All rights reserved.
//

import UIKit

class ResultableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var registrationButton: UIButton!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

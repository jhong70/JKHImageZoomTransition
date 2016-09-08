//
//  JKHCorgiTableViewCell.swift
//  TransitionPlayer
//
//  Created by Joon Hong on 8/5/16.
//  Copyright © 2016 JoonKiHong. All rights reserved.
//

import UIKit

class JKHCorgiTableViewCell: UITableViewCell {
    
    @IBOutlet weak var corgiImageView: UIImageView!
    @IBOutlet weak var corgiTitleLabel: UILabel!
    @IBOutlet weak var corgiSubtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

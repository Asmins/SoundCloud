//
//  ActivityTableViewCell.swift
//  SoundCloud
//
//  Created by admin on 27.09.16.
//  Copyright © 2016 Mozi. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var titleInImageViewLabel: UILabel!
    @IBOutlet weak var subTitleinImageViewLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageViewForUser: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var idPlayList = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

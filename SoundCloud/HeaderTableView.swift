//
//  HeaderTableView.swift
//  SoundCloud
//
//  Created by admin on 26.09.16.
//  Copyright © 2016 Mozi. All rights reserved.
//

import UIKit

class HeaderTableView: UITableViewHeaderFooterView {

    @IBOutlet weak var imageViewForUserImage: UIImageView!
    @IBOutlet weak var labelForUserName: UILabel!
    @IBOutlet weak var labelForUserNickName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

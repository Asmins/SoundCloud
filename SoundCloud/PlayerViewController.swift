//
//  PlayerViewController.swift
//  SoundCloud
//
//  Created by admin on 29.09.16.
//  Copyright © 2016 Mozi. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    var viewModel = PlayerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.viewModel.setupMainView(self,imageView: mainImageView, titleLabel: titileLabel, subTitleLabel: subTitle)
    }
    
    @IBAction func playPauseButtonAction(sender: AnyObject) {
        self.viewModel.playPause(playPauseButton)
    }
    
    @IBAction func nextTrackButtonAction(sender: AnyObject) {
        self.viewModel.nextTrack(playPauseButton, imageView: mainImageView, titleLabel: titileLabel, subTitleLabel: subTitle)
    }
    
    @IBAction func previousTrackButtonAction(sender: AnyObject) {
        self.viewModel.previousTrack(playPauseButton, imageView: mainImageView, titleLabel: titileLabel, subTitleLabel: subTitle)
    }
    
    
}

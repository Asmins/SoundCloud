//
//  PlayerViewController.swift
//  SoundCloud
//
//  Created by admin on 29.09.16.
//  Copyright © 2016 Mozi. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    var viewModel = PlayerViewModel()
    var titleText:String!
    var subTitleText:String!
    var url:NSURL!
    var myValue = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.transform = CGAffineTransformScale(progressView.transform, 1, 5)
        self.title = "PLAYER"
        self.mainImageView.sd_setImageWithURL(url)
        self.titileLabel.text = titleText
        self.subTitle.text = subTitleText
    }
    
    @IBAction func playPauseButtonAction(sender: AnyObject) {
        if myValue == 0{
            playPauseButton.setImage(UIImage(named: "Play"), forState: UIControlState.Normal)
            myValue = 1
        }else{
            playPauseButton.setImage(UIImage(named: "Pause"), forState: UIControlState.Normal)
            myValue = 0
        }
    }
    
    @IBAction func nextTrackButtonAction(sender: AnyObject) {
        
    }

    @IBAction func previousTrackButtonAction(sender: AnyObject) {
    }
    
}

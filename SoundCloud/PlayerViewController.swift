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
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var subTitle: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    var player:AVPlayer?
    var avItem: AVPlayerItem?
    
    var viewModel = PlayerViewModel()
    var titleText:String!
    var subTitleText:String!
    var url:NSURL!
    var myValue = 1
    
    var audioPlayer:AVAudioPlayer!
    
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
            player?.pause()
        }else{
            let url = "https://api.soundcloud.com/tracks/\(self.viewModel.arrayUrl[0])/stream?client_id=7467688f360c6055fb679c3bd739acbc"
            avItem = AVPlayerItem(URL: NSURL(string:url)!)
            player = AVPlayer(playerItem: avItem)
            player?.play()
            
            playPauseButton.setImage(UIImage(named: "Pause"), forState: UIControlState.Normal)
            myValue = 0
        }
    }
    
    @IBAction func nextTrackButtonAction(sender: AnyObject) {
        
    }
    
    @IBAction func previousTrackButtonAction(sender: AnyObject) {
    }
    
}

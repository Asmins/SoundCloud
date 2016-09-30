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
   
    var viewModel = PlayerViewModel()
    
    var audioPlayer:AVAudioPlayer!
    var url:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.transform = CGAffineTransformScale(progressView.transform, 1, 5)
        self.title = "PLAYER"
        self.mainImageView.sd_setImageWithURL(self.viewModel.url)
        self.titileLabel.text = self.viewModel.titleText
        self.subTitle.text = self.viewModel.subTitleText
    }
    
    @IBAction func playPauseButtonAction(sender: AnyObject) {
        if self.viewModel.myValue == 0{
            playPauseButton.setImage(UIImage(named: "Play"), forState: UIControlState.Normal)
            self.viewModel.myValue = 1
            self.viewModel.player?.pause()
        }else{
            playMusic(self.viewModel.count)
            playPauseButton.setImage(UIImage(named: "Pause"), forState: UIControlState.Normal)
            self.viewModel.myValue = 0
        }
    }
    
    @IBAction func nextTrackButtonAction(sender: AnyObject) {
        print(self.viewModel.arrayTrack.count)
        
        if self.viewModel.count != self.viewModel.arrayTrack.count{
            self.viewModel.count = self.viewModel.count + 1
            playMusic(self.viewModel.count)
            }else{
            print(self.viewModel.count)
            print("\(self.viewModel.count) this count == self.viewModel.arrayTrack.count")
        }
    }
    
    @IBAction func previousTrackButtonAction(sender: AnyObject) {
        
    }
    
    
    func playMusic(count:Int) {
        url = "https://api.soundcloud.com/tracks/\(self.viewModel.arrayTrack[count])/stream?client_id=7467688f360c6055fb679c3bd739acbc"
        print(url)
        self.viewModel.avItem = AVPlayerItem(URL: NSURL(string:url)!)
        self.viewModel.player = AVPlayer(playerItem: self.viewModel.avItem)
        self.viewModel.player?.play()
        
    }
    
}

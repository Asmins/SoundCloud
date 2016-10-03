//
//  PlayerViewModel.swift
//  SoundCloud
//
//  Created by admin on 29.09.16.
//  Copyright © 2016 Mozi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AVFoundation
import AVKit

class PlayerViewModel {
    
    var timeObserver: AnyObject?
    var currentSeconds = 0.0
    var currentMinutest = 0
    
    var player:AVPlayer?
    
    var avItem: AVPlayerItem?
    var time = 0.0
    var titleText:String!
    var subTitleText:String!
    var url:NSURL!
    var myValue = 1
    
    var count = 0
    var arrayTrack = [Int]()
    var arrayUrl = [Int]()
    var trackArray = [Track]()
    
    func getTrackInfo(){
        for i in 0..<arrayTrack.count{
            Alamofire.request(.GET,"https://api.soundcloud.com/tracks/\(arrayTrack[i])?client_id=7467688f360c6055fb679c3bd739acbc").responseJSON{ response in
                if response.data != nil{
                    self.parseData(response.data!)
                }
            }
        }
    }
    
    func parseData(data:NSData) {
        let json = JSON(data:data)
        let user = json["user"]
        let track = Track()
        track.title = user["username"].stringValue
        track.urlImage = user["avatar_url"].stringValue
        track.subTitle = json["title"].stringValue
        trackArray.append(track)
    }
    
    func playMusic(button:UIButton) {
        let url = "https://api.soundcloud.com/tracks/\(arrayTrack[count])/stream?client_id=7467688f360c6055fb679c3bd739acbc"
        avItem = AVPlayerItem(URL: NSURL(string:url)!)
        player = AVPlayer(playerItem: avItem)
        player?.play()
        button.setImage(UIImage(named: "Pause"), forState: UIControlState.Normal)
    }
    
    func playPause(button:UIButton)  {
        if myValue == 0{
            button.setImage(UIImage(named: "Play"), forState: UIControlState.Normal)
            myValue = 1
            time = (player?.currentTime().seconds)!
            print(time)
            player?.pause()
        }else{
            button.setImage(UIImage(named: "Pause"), forState: UIControlState.Normal)
            myValue = 0
             let timeScale = self.player?.currentItem?.asset.duration.timescale
            if time != 0 {
                let p = CMTimeMakeWithSeconds(time, timeScale!)
                player?.seekToTime(p, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                player?.play()
            }else{
                playMusic(button)
            }
        }
    }
    
    func nextTrack(button:UIButton,imageView:UIImageView,titleLabel:UILabel,subTitleLabel:UILabel) {
        if count != arrayTrack.count - 1{
            count = count + 1
            let url = NSURL(string: trackArray[count].urlImage)
            imageView.sd_setImageWithURL(url)
            titleLabel.text = trackArray[count].title
            subTitleLabel.text = trackArray[count].subTitle
            playMusic(button)
        }
    
        if count == arrayTrack.count - 1{
            count = -1
        }
    }
 /*
    func playerObserver(trackSlider:UISlider) {
        timeObserver = player?.addPeriodicTimeObserverForInterval(CMTimeMakeWithSeconds(1.0 / 60.0, Int32(NSEC_PER_SEC)), queue: nil, usingBlock: {
            time in
            self.positionChanged(trackSlider)
        })
        
    }*/
    
    func previousTrack(button:UIButton,imageView:UIImageView,titleLabel:UILabel,subTitleLabel:UILabel) {
        if count == 0 {
            count = arrayTrack.count - 1
            setupLabel(button, imageView: imageView, titleLabel: titleLabel, subTitleLabel: subTitleLabel)
            playMusic(button)
        }else{
            count -= 1
            setupLabel(button, imageView: imageView, titleLabel: titleLabel, subTitleLabel: subTitleLabel)
            playMusic(button)
        }
    }
    
    func setupMainView(viewController:UIViewController,imageView:UIImageView,titleLabel:UILabel,subTitleLabel:UILabel) {
        getTrackInfo()
        count = 0
        viewController.title = "PLAYER"
        imageView.sd_setImageWithURL(url)
        titleLabel.text = titleText
        subTitleLabel.text = subTitleText
    }
    
    
    func setupLabel(button:UIButton,imageView:UIImageView,titleLabel:UILabel,subTitleLabel:UILabel){
        let url = NSURL(string: trackArray[count].urlImage)
        imageView.sd_setImageWithURL(url)
        titleLabel.text = trackArray[count].title
        subTitleLabel.text = trackArray[count].subTitle
    }
    
    
    func positionChanged(trackSlider:UISlider) {
        let duration = (player!.currentItem!.duration.seconds) / 1000.0
        currentSeconds = (player?.currentTime().seconds)! / Double((player?.currentTime().timescale)!)
        let value =  currentSeconds / duration
        trackSlider.value = Float(value)
    }
    
    
    func changeTime(trackSlider:UISlider){
        let seconds = Double(trackSlider.value) * Double((player?.currentItem?.duration.seconds)! / 1000.0)
        let timeScale = self.player!.currentItem!.asset.duration.timescale;
        let time = CMTimeMakeWithSeconds(seconds, timeScale);
        player?.seekToTime(time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        player?.play()
    }
}

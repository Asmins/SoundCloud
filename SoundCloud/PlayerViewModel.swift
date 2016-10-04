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
    
    var type:String!
    var track:Int!
    
    var avItem: AVPlayerItem?
    var time = 0.0
    var titleText:String!
    var subTitleText:String!
    var timeText = [String]()
    var url:NSURL!
    var myValue = 1
    
    var count:Int!
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
    
    func playMusic(button:UIButton,slider:UISlider) {
        player?.pause()
        var url = ""
        
        switch type {
        case "playlist":
            url = "https://api.soundcloud.com/tracks/\(arrayTrack[count])/stream?client_id=7467688f360c6055fb679c3bd739acbc"
        case "track":
            url = "https://api.soundcloud.com/tracks/\(track)/stream?client_id=7467688f360c6055fb679c3bd739acbc"
        default:
            print("Error")
        }
        
        avItem = AVPlayerItem(URL: NSURL(string:url)!)
        player = AVPlayer(playerItem: avItem)
        slider.value = 0
        player?.play()
        slider.setValue(Float((player?.currentTime().seconds)!), animated: true)
        button.setImage(UIImage(named: "Pause"), forState: UIControlState.Normal)
    }
    
    func playPause(button:UIButton,slider:UISlider,timeLabel:UILabel)  {
        if myValue == 0{
            button.setImage(UIImage(named: "Play"), forState: UIControlState.Normal)
            myValue = 1
            time = (player?.currentTime().seconds)!
            player?.pause()
        }else{
            button.setImage(UIImage(named: "Pause"), forState: UIControlState.Normal)
            if timeText.isEmpty == false {
                switch type {
                case "playlist":
                    timeLabel.text = timeText[count]
                case "track":
                    timeLabel.text = timeText.first
                default:
                    print("Error")
                }
            }
            myValue = 0
            let timeScale = self.player?.currentItem?.asset.duration.timescale
            if time != 0 {
                let p = CMTimeMakeWithSeconds(time, timeScale!)
                player?.seekToTime(p, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                player?.play()
                
            }else{
                playMusic(button,slider: slider)
            }
        }
    }
    
    func nextTrack(button:UIButton,imageView:UIImageView,titleLabel:UILabel,subTitleLabel:UILabel,slider:UISlider,timeLabel:UILabel) {
        
        if type != "track"{
            if count != arrayTrack.count - 1{
                count = count + 1
                let url = NSURL(string: trackArray[count].urlImage)
                imageView.sd_setImageWithURL(url)
                titleLabel.text = trackArray[count].title
                subTitleLabel.text = trackArray[count].subTitle
                timeLabel.text = timeText[count]
                playMusic(button,slider: slider)
            }else{
                count = 0
                let url = NSURL(string: trackArray[count].urlImage)
                imageView.sd_setImageWithURL(url)
                titleLabel.text = trackArray[count].title
                subTitleLabel.text = trackArray[count].subTitle
                timeLabel.text = timeText[count]
                playMusic(button,slider: slider)
            }
            
            if count == arrayTrack.count - 1{
                count = arrayTrack.count - 1
            }
        }
    }
    
    func previousTrack(button:UIButton,imageView:UIImageView,titleLabel:UILabel,subTitleLabel:UILabel,slider:UISlider,timeLabel:UILabel) {
        if type != "track"{
            if count == 0 {
                count = arrayTrack.count - 1
                setupLabel(button, imageView: imageView, titleLabel: titleLabel, subTitleLabel: subTitleLabel,timeLabel: timeLabel)
                playMusic(button,slider: slider)
            }else{
                count = count - 1
                setupLabel(button, imageView: imageView, titleLabel: titleLabel, subTitleLabel: subTitleLabel,timeLabel: timeLabel)
                playMusic(button,slider: slider)
            }
        }
    }
    
    func setupMainView(viewController:UIViewController,imageView:UIImageView,titleLabel:UILabel,subTitleLabel:UILabel) {
        getTrackInfo()
        viewController.title = "PLAYER"
        imageView.sd_setImageWithURL(url)
        titleLabel.text = titleText
        subTitleLabel.text = subTitleText
    }
    
    
    func setupLabel(button:UIButton,imageView:UIImageView,titleLabel:UILabel,subTitleLabel:UILabel,timeLabel:UILabel){
        let url = NSURL(string: trackArray[count].urlImage)
        imageView.sd_setImageWithURL(url)
        titleLabel.text = trackArray[count].title
        subTitleLabel.text = trackArray[count].subTitle
        timeLabel.text = timeText[count]
    }
    
    func changeTime(trackSlider:UISlider){
        let timeScale = self.player!.currentItem!.asset.duration.timescale;
        player?.pause()
        player?.seekToTime(CMTimeMakeWithSeconds(NSTimeInterval(trackSlider.value), timeScale) , toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        player?.play()
    }
    
    func updateTimeLabel(timeLabel:UILabel) {
        timeLabel.text = player?.currentTime().seconds.minuteSecondMS
    }
    
    
    
}

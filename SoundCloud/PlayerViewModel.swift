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
    
    var currentSeconds = 0.0
    var currentMinutest = 0
    
    var player:AVPlayer?
    var avItem: AVPlayerItem?
    
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
    
  /*  func positionChanged() {
        let duration = (avItem?.duration.seconds)! / 1000.0
        currentSeconds = (player?.currentTime().seconds)! / player?.currentTime().timescale
        // currentSeconds = Float((player?.currentTime().value)! / Int64((player?.currentTime().timescale)!))
        let value =  currentSeconds / duration
        trackSlider.value = value
    }
    */
    
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
            player?.pause()
        }else{
            button.setImage(UIImage(named: "Pause"), forState: UIControlState.Normal)
            myValue = 0
            playMusic(button)
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
}

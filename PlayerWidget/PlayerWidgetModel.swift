//
//  PlayerWidgetModel.swift
//  SoundCloud
//
//  Created by admin on 05.10.16.
//  Copyright © 2016 Mozi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AVFoundation
import AVKit

class PlayerWidgetModel {
    
    var player:AVPlayer?
    var item:AVPlayerItem?
    
    var myValue = 1
    
    func playPause(button:UIButton,url:String){
        if myValue == 0{
            button.setImage(UIImage(named: "Play"), forState: UIControlState.Normal)
            myValue = 1
        }
        else{
            item = AVPlayerItem(URL: NSURL(string: url)!)
            player = AVPlayer(playerItem: item)
            player?.play()
            
            button.setImage(UIImage(named: "Pause"), forState: UIControlState.Normal)
            myValue = 0
        }
    }
}

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

class PlayerViewModel {
    var player:AVPlayer?
    var avItem: AVPlayerItem?
    
    var titleText:String!
    var subTitleText:String!
    var url:NSURL!
    var myValue = 1
    
    var count:Int!
    var arrayTrack = [Int]()
    /*var arrayUrl = [Int]()
    
    func getTrackInfo(i:Int!){
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
        arrayUrl.append(json["id"].int!)
    }
    */
}

//
//  TrackViewModel.swift
//  SoundCloud
//
//  Created by admin on 28.09.16.
//  Copyright © 2016 Mozi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TrackViewModel {
    var track = Track()
    var arrayTracks = [Track]()

    func getTrack(tableView:UITableView,activityIndicator:UIActivityIndicatorView) {
        let url = "https://api.soundcloud.com/playlists/\(track.idPlayList)/tracks?client_id=7467688f360c6055fb679c3bd739acbc"
        Alamofire.request(.GET, url).responseJSON{ response in
            if response.data != nil{
                self.parseJsonTrack(response.data!,activityIndicator: activityIndicator)
            }
            tableView.reloadData()
        }
    }
    
    func parseJsonTrack(data:NSData,activityIndicator:UIActivityIndicatorView) {
        activityIndicator.startAnimating()
        let json = JSON(data:data)
        for i in 0..<json.count{
            let track = Track()
            track.title = json[i]["user"]["username"].stringValue
            track.subTitle = json[i]["title"].stringValue
            let time = json[i]["duration"].int
            let formattedTime = time!.msToSeconds.minuteSecondMS
            track.time = formattedTime
            track.urlImage = json[i]["user"]["avatar_url"].stringValue
            track.idTrack = json[i]["id"].int
            arrayTracks.append(track)
        }
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
    }
}

extension NSTimeInterval {
    var minuteSecondMS: String {
        return String(format:"%d:%02d", minute, second, millisecond)
    }
    var minute: Int {
        return Int(self/60.0 % 60)
    }
    var second: Int {
        return Int(self % 60)
    }
    var millisecond: Int {
        return Int(self*1000 % 1000 )
    }
}

extension Int {
    var msToSeconds: Double {
        return Double(self) / 1000
    }
}

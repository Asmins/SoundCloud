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

class PlayerWidgetModel {
    
    let url = "https://api.soundcloud.com/me/activities?limit=100&oauth_token="
    var token = ""
    
    func getNewActivity(label:UILabel)  {
        token = NSUserDefaults(suiteName: "group.playerWidget")?.objectForKey("cache") as! String
        Alamofire.request(.GET,url + "\(token)").responseJSON{ response in
            if response.data != nil{
                label.text = "\(self.token)"
                self.parseData(response.data!)
            }
        }
    }
    
    func parseData(data:NSData) {
        let json = JSON(data: data)
        print(json)
    }
}

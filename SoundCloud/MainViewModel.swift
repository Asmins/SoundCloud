//
//  MainViewModel.swift
//  SoundCloud
//
//  Created by admin on 27.09.16.
//  Copyright © 2016 Mozi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MainViewModel {
    
    var token: String!
    var user = User()
    
    func requestMe(token: String,tableView:UITableView) {
        let url = NSURL(string: "https://api.soundcloud.com/me.json?oauth_token=\(token)")!
        Alamofire.request(.GET, url).responseJSON{ response in
            if response.data != nil{
                self.parseJson(response.data!)
            }
            tableView.reloadData()
        }
    }
    
    func parseJson(data:NSData){
        let json = JSON(data: data)
        print(json)
        user.fullName = json["full_name"].stringValue
        user.nickName = json["username"].stringValue
        user.url = json["avatar_url"].stringValue
        user.followersCount = json["followers_count"].int
        user.followingCount = json["followings_count"].int
    }
}

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
    var arrayActivity = [Activity]()
    var count = 0
    
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
        user.fullName = json["full_name"].stringValue
        user.nickName = json["username"].stringValue
        user.url = json["avatar_url"].stringValue
        user.followersCount = json["followers_count"].int
        user.followingCount = json["followings_count"].int
    }
    
    func getData(token:String,tableView:UITableView) {
        let url = NSURL(string:"https://api.soundcloud.com/me/activities?&oauth_token=\(token)")!
        Alamofire.request(.GET, url).responseJSON{ response in
            if response.data != nil {
                self.parseDataForActivity(response.data!)
            }
            tableView.reloadData()
        }
    }
    
    func parseDataForActivity(data:NSData) -> [Activity]{
        let json = JSON(data:data)
        let collection = json["collection"]
        count = json["collection"].count
        for i in 0..<collection.count{
            var activity = Activity()
            activity.type = collection[i]["type"].stringValue
            let origin = collection[i]["origin"]
            let user = origin["user"]
            activity.userName = user["username"].stringValue
            activity.urlUser = user["avatar_url"].stringValue

            arrayActivity.append(activity)
        }
        return arrayActivity
    }
}

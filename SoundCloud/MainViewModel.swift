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
    var arrayPlaylists = [Playlist]()
    var count = 0
    
    func requestMe(tableView:UITableView) {
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
    
    func getData(tableView:UITableView,activityIndicator:UIActivityIndicatorView) {
        let url = NSURL(string:"https://api.soundcloud.com/me/activities?limit=100&oauth_token=\(token)")!
        Alamofire.request(.GET, url).responseJSON{ response in
            if response.data != nil {
                self.parseDataForActivity(response.data!,activityIndicator: activityIndicator)
                self.count = self.arrayActivity.count
                activityIndicator.hidesWhenStopped = true
            }
            tableView.reloadData()
        }
    }
    
    func parseDataForActivity(data:NSData,activityIndicator:UIActivityIndicatorView) -> [Activity]{
        activityIndicator.startAnimating()
        let json = JSON(data:data)
        let collection = json["collection"]
        for i in 0..<collection.count{
            let activity = Activity()
            activity.type = collection[i]["type"].stringValue
            let origin = collection[i]["origin"]
            if origin.isEmpty != true {
                let user = origin["user"]
                let time = origin["duration"].int
                let formattedTime = time?.msToSeconds.minuteSecondMS
                activity.duration = formattedTime
                
                switch activity.type {
                case "playlist":
                    activity.trackCount = origin["track_count"].int
                    activity.idPlaylist = origin["id"].int
                case "track":
                    activity.trackCount = 0
                    activity.idTrack = origin["id"].int
                case "track-repost":
                    activity.trackCount = 0
                    activity.idTrack = origin["id"].int
                case "playlist-repost":
                    activity.trackCount = origin["track_count"].int
                    activity.idPlaylist = origin["id"].int
                default:
                    print("Error")
                }
                
                activity.title = origin["title"].stringValue
                activity.userName = user["username"].stringValue
                activity.urlUser = user["avatar_url"].stringValue
                arrayActivity.append(activity)
            }
        }
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        return arrayActivity
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("Header") as! HeaderTableViewCell
        header.labelForUserName.text = user.fullName
        header.labelForUserNickName.text = user.nickName
        header.followersCountLabel.text = "\(user.followersCount)"
        header.followingCountLabel.text = "\(user.followingCount)"
        if user.url != nil{
            let url = NSURL(string: user.url)
            header.imageViewForUserImage.sd_setImageWithURL(url)
            header.imageViewForUserImage.layer.masksToBounds = true
        }
        return header
    }
    
    func setupTableView(tableView:UITableView){
        tableView.registerNib(UINib(nibName: "HeaderTableViewCell",bundle: nil), forHeaderFooterViewReuseIdentifier: "Header")
        tableView.registerNib(UINib(nibName: "ActivityTableViewCell",bundle:nil), forCellReuseIdentifier: "ActivityCell")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath,activityIndicator:UIActivityIndicatorView) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell") as! ActivityTableViewCell
        cell.titleLabel.text = "\(arrayActivity[indexPath.row].userName) posted \(arrayActivity[indexPath.row].type)"
        let url = NSURL.init(string: arrayActivity[indexPath.row].urlUser)
        cell.imageViewForUser.sd_setImageWithURL(url)
        cell.mainImageView.sd_setImageWithURL(url)
        cell.subTitleinImageViewLabel.text = arrayActivity[indexPath.row].title
        cell.titleInImageViewLabel.text = arrayActivity[indexPath.row].userName
        
        if arrayActivity[indexPath.row].trackCount != 0 {
            cell.view.hidden = false
            cell.countLabel.text = "\(arrayActivity[indexPath.row].trackCount)"
            cell.idPlayList = arrayActivity[indexPath.row].idPlaylist
            cell.timeLabel.text = arrayActivity[indexPath.row].duration
        }else{
            cell.view.hidden = true
            cell.countLabel.text = ""
            cell.timeLabel.text = arrayActivity[indexPath.row].duration
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath,viewController:UIViewController) {
        let cell =  tableView.cellForRowAtIndexPath(indexPath) as! ActivityTableViewCell
        switch arrayActivity[indexPath.row].type{
        case "playlist":
            let controller = viewController.storyboard?.instantiateViewControllerWithIdentifier("TrackViewController") as! TrackViewController
            controller.title = arrayActivity[indexPath.row].title
            controller.viewModel.track.idPlayList = cell.idPlayList
            viewController.navigationController?.pushViewController(controller, animated: true)
            tableView.reloadData()
        case "track":
            let controller = viewController.storyboard?.instantiateViewControllerWithIdentifier("PlayerView") as! PlayerViewController
            controller.viewModel.type = arrayActivity[indexPath.row].type
            controller.viewModel.titleText = arrayActivity[indexPath.row].title
            controller.viewModel.subTitleText = arrayActivity[indexPath.row].userName
            controller.viewModel.timeText.append(arrayActivity[indexPath.row].duration)
            let url = NSURL(string: arrayActivity[indexPath.row].urlUser)
            controller.viewModel.url = url
            controller.viewModel.track = arrayActivity[indexPath.row].idTrack
            
            for i in 0..<arrayActivity.count{
                if arrayActivity[i].idTrack != nil{
                    controller.viewModel.arrayTrack.append(arrayActivity[i].idTrack)
                }
            }
            viewController.navigationController?.pushViewController(controller, animated: true)
            tableView.reloadData()
        case "track-repost":
            let controller = viewController.storyboard?.instantiateViewControllerWithIdentifier("PlayerView") as! PlayerViewController
            controller.viewModel.type = arrayActivity[indexPath.row].type
            controller.viewModel.titleText = arrayActivity[indexPath.row].title
            controller.viewModel.subTitleText = arrayActivity[indexPath.row].userName
            controller.viewModel.timeText.append(arrayActivity[indexPath.row].duration)
            let url = NSURL(string: arrayActivity[indexPath.row].urlUser)
            controller.viewModel.url = url
            controller.viewModel.track = arrayActivity[indexPath.row].idTrack
            
            for i in 0..<arrayActivity.count{
                if arrayActivity[i].idTrack != nil{
                    controller.viewModel.arrayTrack.append(arrayActivity[i].idTrack)
                }
            }
            viewController.navigationController?.pushViewController(controller, animated: true)
            tableView.reloadData()
        case "playlist-repost":
            let controller = viewController.storyboard?.instantiateViewControllerWithIdentifier("TrackViewController") as! TrackViewController
            controller.title = arrayActivity[indexPath.row].title
            controller.viewModel.track.idPlayList = cell.idPlayList
            viewController.navigationController?.pushViewController(controller, animated: true)
            tableView.reloadData()
        default:
            print("Error")
        }
    }
    func setupMainView(tableView:UITableView,navController:UINavigationController,viewController:UIViewController,activityIndicator:UIActivityIndicatorView) {
        setupTableView(tableView)
        navController.navigationBar.barTintColor = UIColor(red:255/255, green: 116/255, blue: 0/255, alpha:1)
        viewController.title = "FEED"
        navController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        requestMe(tableView)
        getData(tableView,activityIndicator: activityIndicator)
    }
    
}

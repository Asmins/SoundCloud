//
//  MainViewController.swift
//  SoundCloud
//
//  Created by admin on 26.09.16.
//  Copyright © 2016 Mozi. All rights reserved.
//

import UIKit
import SDWebImage

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView(tableView)
        navigationController?.navigationBar.barTintColor = UIColor(red:255/255, green: 116/255, blue: 0/255, alpha:1)
        self.title = "FEED"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.viewModel.requestMe(tableView)
        self.viewModel.getData(tableView)
        self.viewModel.getMainImage(tableView)
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell") as! ActivityTableViewCell
        cell.titleLabel.text = "\(self.viewModel.arrayActivity[indexPath.row].userName) posted \(self.viewModel.arrayActivity[indexPath.row].type)"
        let url = NSURL.init(string: self.viewModel.arrayActivity[indexPath.row].urlUser)
        cell.imageViewForUser.sd_setImageWithURL(url)
        cell.mainImageView.sd_setImageWithURL(url)
        cell.subTitleinImageViewLabel.text = self.viewModel.arrayActivity[indexPath.row].title
        cell.titleInImageViewLabel.text = self.viewModel.arrayActivity[indexPath.row].userName
        
        if self.viewModel.arrayActivity[indexPath.row].trackCount != 0 {
            cell.view.hidden = false
            cell.countLabel.text = "\(self.viewModel.arrayActivity[indexPath.row].trackCount)"
            cell.idPlayList = self.viewModel.arrayActivity[indexPath.row].idPlaylist
            cell.timeLabel.text = self.viewModel.arrayActivity[indexPath.row].duration
        }else{
            cell.view.hidden = true
            cell.countLabel.text = ""
            cell.timeLabel.text = self.viewModel.arrayActivity[indexPath.row].duration
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell =  tableView.cellForRowAtIndexPath(indexPath) as! ActivityTableViewCell
        
        if self.viewModel.arrayActivity[indexPath.row].type == "playlist" {
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("TrackViewController") as! TrackViewController
            controller.title = self.viewModel.arrayActivity[indexPath.row].title
            controller.viewModel.track.idPlayList = cell.idPlayList
            self.navigationController?.pushViewController(controller, animated: true)
            tableView.reloadData()
        }else{
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("PlayerView") as! PlayerViewController
            controller.viewModel.type = self.viewModel.arrayActivity[indexPath.row].type
            controller.viewModel.titleText = self.viewModel.arrayActivity[indexPath.row].title
            controller.viewModel.subTitleText = self.viewModel.arrayActivity[indexPath.row].userName
            controller.viewModel.timeText.append(self.viewModel.arrayActivity[indexPath.row].duration)
            let url = NSURL(string: self.viewModel.arrayActivity[indexPath.row].urlUser)
            controller.viewModel.url = url
            controller.viewModel.track = self.viewModel.arrayActivity[indexPath.row].idTrack

            for i in 0..<self.viewModel.arrayActivity.count{
                if self.viewModel.arrayActivity[i].idTrack != nil{
                    controller.viewModel.arrayTrack.append(self.viewModel.arrayActivity[i].idTrack)
                }
            }
            self.navigationController?.pushViewController(controller, animated: true)
            tableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 230
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("Header") as! HeaderTableViewCell
        header.labelForUserName.text = self.viewModel.user.fullName
        header.labelForUserNickName.text = self.viewModel.user.nickName
        header.followersCountLabel.text = "\(self.viewModel.user.followersCount)"
        header.followingCountLabel.text = "\(self.viewModel.user.followingCount)"
        if self.viewModel.user.url != nil{
            let url = NSURL(string: self.viewModel.user.url)
            header.imageViewForUserImage.sd_setImageWithURL(url)
            header.imageViewForUserImage.layer.masksToBounds = true
        }
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}


private extension MainViewController {
    
    func setupTableView(tableView:UITableView){
        tableView.registerNib(UINib(nibName: "HeaderTableViewCell",bundle: nil), forHeaderFooterViewReuseIdentifier: "Header")
        tableView.registerNib(UINib(nibName: "ActivityTableViewCell",bundle:nil), forCellReuseIdentifier: "ActivityCell")
    }
}

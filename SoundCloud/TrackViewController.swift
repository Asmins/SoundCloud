//
//  TrackViewController.swift
//  SoundCloud
//
//  Created by admin on 28.09.16.
//  Copyright © 2016 Mozi. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class TrackViewController: UIViewController {
    
    @IBOutlet var subTitle: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var heightBottomView: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var viewModel = TrackViewModel()
   
    var player:AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heightBottomView.constant = 0
        let controllerCount = self.storyboard?.instantiateViewControllerWithIdentifier("PlayerView") as! PlayerViewController
        controllerCount.viewModel.count = 0
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.setupTableView(tableView)
        self.viewModel.getTrack(tableView,activityIndicator:activityIndicator)
    }
    
    @IBAction func playMusicButton(sender: AnyObject) {
        self.viewModel.playPause(player,button: playPauseButton)
    }
}

extension TrackViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrayTracks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell") as! TrackTableViewCell
        
        if self.viewModel.arrayTracks.count != 0 {
            cell.timeLabel.text = viewModel.arrayTracks[indexPath.row].time
            cell.topTItleLabel.text = viewModel.arrayTracks[indexPath.row].title
            cell.titleLabel.text = viewModel.arrayTracks[indexPath.row].subTitle
            let url = NSURL(string: self.viewModel.arrayTracks[indexPath.row].urlImage)
            cell.imageViewForPhotoAlbum.sd_setImageWithURL(url)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("PlayerView") as! PlayerViewController
        let url = NSURL(string: self.viewModel.arrayTracks[indexPath.row].urlImage)
        controller.viewModel.url = url
        controller.viewModel.type = "playlist"
        for i in 0..<self.viewModel.arrayTracks.count{
            controller.viewModel.timeText.append(self.viewModel.arrayTracks[i].time)
        }
        controller.viewModel.titleText = self.viewModel.arrayTracks[indexPath.row].title
        controller.viewModel.subTitleText = self.viewModel.arrayTracks[indexPath.row].subTitle
       
        for i in 0..<self.viewModel.arrayTracks.count{
            controller.viewModel.arrayTrack.append(self.viewModel.arrayTracks[i].idTrack)
        }
        controller.viewModel.count = indexPath.row
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
        tableView.reloadData()
    }
}

extension TrackViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
}

extension TrackViewController {
    func setupTableView(tableView:UITableView) {
        tableView.registerNib(UINib(nibName:"TrackTableViewCell",bundle: nil), forCellReuseIdentifier: "TrackCell")
    }
}

extension TrackViewController: PassData {
    func passData(player: AVPlayer,title:String,subTitle:String) {
        self.player = player
        self.titleLabel.text = title
        self.subTitle.text = subTitle
        heightBottomView.constant = 50
    }
}

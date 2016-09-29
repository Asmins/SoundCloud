//
//  TrackViewController.swift
//  SoundCloud
//
//  Created by admin on 28.09.16.
//  Copyright © 2016 Mozi. All rights reserved.
//

import UIKit

class TrackViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel = TrackViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.setupTableView(tableView)
        self.viewModel.getTrack(tableView)
    }
}

extension TrackViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrayTracks.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TrackCell") as! TrackTableViewCell
        if self.viewModel.arrayTracks.count != 0 {
            print(viewModel.arrayTracks[indexPath.row].time)
        cell.timeLabel.text = viewModel.arrayTracks[indexPath.row].time
        cell.topTItleLabel.text = viewModel.arrayTracks[indexPath.row].title
        cell.titleLabel.text = viewModel.arrayTracks[indexPath.row].subTitle
        let url = NSURL(string: self.viewModel.arrayTracks[indexPath.row].urlImage)
        cell.imageViewForPhotoAlbum.sd_setImageWithURL(url)
        }
        return cell
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

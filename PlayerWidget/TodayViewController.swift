//
//  TodayViewController.swift
//  PlayerWidget
//
//  Created by admin on 05.10.16.
//  Copyright © 2016 Mozi. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet var playPauseButton: UIButton!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    
    var viewModel = PlayerWidgetModel()

    @IBAction func playPauseButton(sender: UIButton) {
        let url = NSUserDefaults.init(suiteName: "group.playerWidget")?.valueForKey("url") as? String
        self.viewModel.playPause(playPauseButton,url: url!)
    }
    @IBAction func nextTrackButton(sender: UIButton) {
        titleLabel.text = "next track"
    }
  
    @IBAction func previousTrack(sender: UIButton) {
        titleLabel.text = "previous track"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if let subTitle = NSUserDefaults.init(suiteName: "group.playerWidget")?.valueForKey("subTitle"){
            subTitleLabel.text = subTitle as? String
        }else{
            subTitleLabel.text = "Fucking it`s does not work"
        }
        
        if let title = NSUserDefaults.init(suiteName: "group.playerWidget")?.valueForKey("title"){
            titleLabel.text = title as? String
        }
    }
    
    func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        let margin = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return margin
    }
    
}

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
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitle: UILabel!
    
    var viewModel = PlayerWidgetModel()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getNewActivity(titleLabel)
    }

    func widgetPerformUpdate(completionHandler: ((NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        let margin = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        return margin
    }
    
}

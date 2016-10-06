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
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    var viewModel = MainViewModel()
    var cache = FirstViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.setupMainView(tableView, navController: navigationController!, viewController: self, activityIndicator: activityIndicator)
    }
    
    @IBAction func singOutButton(sender: AnyObject) {
        let alert = UIAlertController(title: "Sign out", message: "You want sign out ?", preferredStyle: .ActionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        let done = UIAlertAction(title: "Sing Out", style: .Destructive, handler: {(action) in
            self.cache.signOut()
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("FirstViewController") as! FirstViewController
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alert.addAction(done)
        alert.addAction(cancel)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.viewModel.tableView(tableView, cellForRowAtIndexPath: indexPath, activityIndicator: activityIndicator)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        return self.viewModel.tableView(tableView, didSelectRowAtIndexPath: indexPath,viewController: self)
    }
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 230
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.viewModel.tableView(tableView, viewForHeaderInSection: section)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}

//
//  MainViewController.swift
//  SoundCloud
//
//  Created by admin on 26.09.16.
//  Copyright © 2016 Mozi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView(tableView)
        navigationController?.navigationBar.barTintColor = UIColor(red:255/255, green: 116/255, blue: 0, alpha:1)
        self.title = "USER INFO"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // Do any additional setup after loading the view.
    }

}

extension MainViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        return cell
    }
}

extension MainViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("Header") as! HeaderTableView
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}


private extension MainViewController {
    
    func setupTableView(tableView:UITableView){
        tableView.registerNib(UINib(nibName: "HeaderTableView",bundle: nil), forHeaderFooterViewReuseIdentifier: "Header")
    }
}

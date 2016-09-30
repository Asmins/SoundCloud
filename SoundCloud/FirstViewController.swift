//
//  FirstViewController.swift
//  SoundCloud
//
//  Created by admin on 26.09.16.
//  Copyright © 2016 Mozi. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    var viewModel = FirstViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? SoundCloudLoginViewController,
            segueID = segue.identifier where segueID == "LoginSegue" {
            controller.authenticator = SoundCloudAuthenticator(oauthState: self.viewModel.oauthState)
            controller.delegate = self
        }
    }
}

extension FirstViewController: SoundCloudLoginResultsDelegate {

    func didSucceed(loginViewController: SoundCloudLoginViewController, authResult: AuthenticationResult) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MainView") as! MainViewController
        let navControler = UINavigationController(rootViewController: controller)
        controller.viewModel.token = authResult.value
        self.presentViewController(navControler, animated: true, completion: nil)
    }
    
   
    func didFail(loginViewController: SoundCloudLoginViewController) {
        let alert = UIAlertController(title: "Error", message: "Please check your login or password and try again", preferredStyle: .Alert)
        let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(doneAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

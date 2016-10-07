//
//  FirstViewController.swift
//  SoundCloud
//
//  Created by admin on 26.09.16.
//  Copyright © 2016 Mozi. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    var cache = NSUserDefaults(suiteName: "group.playerWidget")
    var viewModel = FirstViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(cache!.objectForKey("cache"))
        if cache!.objectForKey("cache") == nil{
        let controller = segue.destinationViewController as? SoundCloudLoginViewController
            if segue.identifier == "LoginSegue" {
                controller!.authenticator = SoundCloudAuthenticator(oauthState: self.viewModel.oauthState)
                controller!.delegate = self
          }
        }else{
            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MainView") as! MainViewController
            let navController = UINavigationController(rootViewController: controller)
            controller.viewModel.token = NSUserDefaults.init().valueForKey("cache") as? String
            self.presentViewController(navController, animated: true, completion: nil)
        }
    }
    
    func signOut(){
        cache!.removeObjectForKey("cache")
    }

}

extension FirstViewController: SoundCloudLoginResultsDelegate {

    func didSucceed(loginViewController: SoundCloudLoginViewController, authResult: AuthenticationResult) {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MainView") as! MainViewController
        let navControler = UINavigationController(rootViewController: controller)
        controller.viewModel.token = authResult.value
        cache!.setObject(authResult.value, forKey: "cache")
        self.presentViewController(navControler, animated: true, completion: nil)
    }
    
   
    func didFail(loginViewController: SoundCloudLoginViewController) {
        let alert = UIAlertController(title: "Error", message: "Please check your login or password and try again", preferredStyle: .Alert)
        let doneAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(doneAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

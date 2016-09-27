//
//  ViewController.swift
//  SoundCloud
//
//  Created by admin on 23.09.16.
//  Copyright © 2016 Mozi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,SoundCloudLoginResultsDelegate {

    let oauthState = OAuthState(
        clientId: "7467688f360c6055fb679c3bd739acbc",
        clientSecret: "8cd5fb0bd4653074d8b6b6a352d81ac5",
        redirectUri: "soundcloud://soundcloud/callback",
        responseType: OAuthResponseType.Token)
    
    var authResult: AuthenticationResult?
    @IBOutlet weak var usernameLabel: UILabel?
    @IBOutlet weak var uriLabel: UILabel?
    
    // MARK: - View Lifecycle
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? SoundCloudLoginViewController,
            segueID = segue.identifier where segueID == "LoginSegue" {
            controller.authenticator = SoundCloudAuthenticator(oauthState: oauthState)
            controller.delegate = self
        }
    }
    
    // MARK: - SoundCloudLoginResultsDelegate
    
    func didSucceed(loginViewController: SoundCloudLoginViewController, authResult: AuthenticationResult) {
        requestMe(authResult.value)
        showAlert("Authenticated!", message: "Received token \(authResult.value)")
    }
    
    func didFail(loginViewController: SoundCloudLoginViewController) {
        showAlert("Error", message: "Failed to authenticate")
    }
    
    // MARK: - Private
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
   
    private func requestMe(token: String) {
        let url = NSURL(string: "https://api.soundcloud.com/me.json?oauth_token=\(token)")!
        let request = NSURLRequest(URL: url)
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
                                   delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        let dataTask = session.dataTaskWithURL(url) { (data, response, error) -> Void in
            
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options:[]) as? [String:AnyObject]
                print(json)
                self.displayMe(json!)
            }
            catch{
                print("Error")
            }
        }
        dataTask.resume()
    }
 
    private func displayMe(jsonDict: [String:AnyObject]) {
        usernameLabel?.text = jsonDict["full_name"] as? String
        uriLabel?.text = jsonDict["country"] as? String
    }
}

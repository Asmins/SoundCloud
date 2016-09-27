//
//  FirstViewModel.swift
//  SoundCloud
//
//  Created by admin on 26.09.16.
//  Copyright © 2016 Mozi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FirstViewModel {
    
    let oauthState = OAuthState(
        clientId: "7467688f360c6055fb679c3bd739acbc",
        clientSecret:"8cd5fb0bd4653074d8b6b6a352d81ac5",
        redirectUri: "soundcloud://soundcloud/callback",
        responseType: OAuthResponseType.Token)
    
    var authResult: AuthenticationResult?
    
    func showAlert(title: String, message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func requestMe(token: String) {
        let url = NSURL(string: "https://api.soundcloud.com/me.json?oauth_token=\(token)")!
        
        Alamofire.request(.GET, url).responseJSON{ response in
            if response.data != nil{
                self.parseJson(response.data!)
            }
        }
    }
    
    func parseJson(data:NSData){
        let json = JSON(data: data)
        print(json)
    }
    
}

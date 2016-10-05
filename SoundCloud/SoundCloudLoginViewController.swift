//
//  SoundCloudLoginViewController.swift
//  SoundCloud
//
//  Created by admin on 26.09.16.
//  Copyright © 2016 Mozi. All rights reserved.
//

import UIKit

protocol SoundCloudLoginResultsDelegate: class {
    func didSucceed(loginViewController: SoundCloudLoginViewController, authResult: AuthenticationResult)
    func didFail(loginViewController: SoundCloudLoginViewController)
}

class SoundCloudLoginViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var webViewForLogin: UIWebView!
    var authenticator: SoundCloudAuthenticator?
    weak var delegate: SoundCloudLoginResultsDelegate?

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        webViewForLogin.sizeToFit()
        startAuthorization()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Private
    
    private func startAuthorization() {
        if let authenticator = self.authenticator {
            let url = authenticator.buildLoginURL()
            webViewForLogin.loadRequest(NSURLRequest(URL: url))
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
    // MARK: - UIWebViewDelegate
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.URL!
        if let authenticator = self.authenticator where authenticator.isOAuthResponse(url) {
            dismissViewControllerAnimated(true, completion: {
                if let authResult = authenticator.resultFromAuthenticationResponse(url), delegate = self.delegate {
                    delegate.didSucceed(self, authResult: authResult)
                } else if let delegate = self.delegate {
                    delegate.didFail(self)
                }
            })
        }
        return true
    }
    
    
}

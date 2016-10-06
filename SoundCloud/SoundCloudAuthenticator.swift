//
//  SoundCloudAuthenticator.swift
//  SoundCloud
//
//  Created by admin on 26.09.16.
//  Copyright © 2016 Mozi. All rights reserved.
//

import Foundation

enum OAuthResponseType: String {
    case Token = "token"
    case Code = "code"
}

struct OAuthState {
    let clientId: String
    let clientSecret: String
    let redirectUri: String
    let responseType: OAuthResponseType
}

struct AuthenticationResult {
    let responseType: OAuthResponseType
    let value: String
}

class SoundCloudAuthenticator {
    let authenticationURLString = "https://soundcloud.com/connect"
    let oauthState: OAuthState
    
    required init(oauthState: OAuthState) {
        self.oauthState = oauthState;
    }
    
    func buildLoginURL() -> NSURL {
        let urlComponents = NSURLComponents(string: authenticationURLString)!
        urlComponents.queryItems = loginParameters()
        return urlComponents.URL!
    }
    
    func resultFromAuthenticationResponse(url: NSURL) -> AuthenticationResult? {
        if !isRedirectToApp(url) {
            return nil
        }
        
        switch self.oauthState.responseType {
        case OAuthResponseType.Token: return retrieveToken(url)
        case OAuthResponseType.Code: return retrieveCode(url)
        }
    }
    
    func isOAuthResponse(url: NSURL) -> Bool {
        return isRedirectToApp(url)
    }
    
    private func loginParameters() -> [NSURLQueryItem] {
        let parameters = [ "client_id" : self.oauthState.clientId,
                           "client_secret" : self.oauthState.clientSecret,
                           "response_type" : self.oauthState.responseType.rawValue,
                           "redirect_uri" : self.oauthState.redirectUri,
                           "display" : "popup" ]
        var queryItems = [NSURLQueryItem]()
        for (name, value) in parameters {
            queryItems.append(NSURLQueryItem(name: name, value: value))
        }
        return queryItems
    }
    
    private func isRedirectToApp(url: NSURL) -> Bool {
        if let ourScheme = NSURL(string: self.oauthState.redirectUri)?.scheme,
            redirectScheme = url.scheme {
            return ourScheme == redirectScheme
        }
        return false
    }
    
  
    private func retrieveToken(url: NSURL) -> AuthenticationResult? {
        if let fragment = url.fragment, accessToken = parameterValue("access_token", fragment: fragment) {
            return AuthenticationResult(responseType: OAuthResponseType.Token, value: accessToken)
        } else {
            return nil
        }
    }
 
    private func retrieveCode(url: NSURL) -> AuthenticationResult? {
        if let fragment = url.query, code = parameterValue("code", fragment: fragment) {
            return AuthenticationResult(responseType: OAuthResponseType.Code, value: code)
        } else {
            return nil
        }
    }
 
    private func parameterValue(name: String, fragment: String) -> String? {
        let pairs = fragment.characters.split { $0 == "&" }.filter({ pair in String(pair).hasPrefix(name + "=") })
        if pairs.count > 0 {
            let subseq = pairs[0].split { $0 == "=" }.map { String($0) }
            return subseq[1]
        }
        return nil
    }
}

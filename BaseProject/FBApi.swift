//
//  FBApi.swift
//  BaseProject
//
//  Created by Valeev Anatoliy on 21/12/2017.
//  Copyright © 2017 Valeev A. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore
import FacebookLogin


class FBApi {
    let readPermissions:[ReadPermission] = [ .publicProfile, .email, .userFriends ]
    
    fileprivate init (){}
    
    private static var sharedFbApi: FBApi = {
        let fbApi = FBApi()
        
        return fbApi
    }()
    
    
    class var shared: FBApi {
        return sharedFbApi
    }
    
    var accessToken:String = ""
    
    func logout(){
        if AccessToken.current != nil {
            LoginManager().logOut()
            accessToken = ""
            print("Success logout")
        }
    }
    
    func login(viewController:UIViewController, successBlock: (() -> ())?, andFailure failureBlock: @escaping (Error?) -> () = { _ in }) {
        
        if let accessToken = AccessToken.current {
            print ("AccessToken: \(accessToken.authenticationToken)")
            return
        }
        LoginManager().logIn(readPermissions: readPermissions, viewController: viewController) { (result) in
            
            switch result {
            case .cancelled:
                LoginManager().logOut()
                failureBlock(nil)
            case .failed(let error):
                failureBlock(error)
                
            case .success(let grantedPermissions, let declinedPermissions, let accessToken) :
                if !declinedPermissions.isEmpty {
                    failureBlock(nil)
                }else{
                    self.accessToken = accessToken.authenticationToken
                    successBlock?()
                    print ("AccessToken: \(accessToken.authenticationToken)")
                }
                
            }
        }
        
    }
    
}



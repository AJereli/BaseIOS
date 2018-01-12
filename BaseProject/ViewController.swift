//
//  ViewController.swift
//  BaseProject
//
//  Created by Valeev Anatoliy on 20/12/2017.
//  Copyright © 2017 Valeev A. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FacebookShare

class ViewController: ViewCntrlBase {
    
    @IBOutlet weak var contentContainer: UIView!
    
    let readPermissions:[ReadPermission] = [ .publicProfile, .email, .userFriends ]
    
    var testView:TestView?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        testView = TestView()
        testView?.text = "asd"
        contentContainer.addSubview(testView!)
    
        
        showLoadOverlay()
        
        
    }
    @IBAction func actLogOut(_ sender: Any) {
        
        FBApi.shared.logout()
    }
    
    @IBAction func actShare(_ sender: Any) {
        FBApi.shared.login(viewController: self, successBlock: nil)
    }
    
    
    func shareFB(_ sender: AnyObject){
        
        let content : LinkShareContent = LinkShareContent(url: URL(string: "https://stackoverflow.com")!)
        
        let dialog : ShareDialog = ShareDialog(content: content)
        dialog.mode = .native
        
        
        do {
            try dialog.show()
            
        }
        catch  {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


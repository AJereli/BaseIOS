//
//  NibLoader.swift
//  SpectorViewParody
//
//  Created by Valeev Anatoliy on 20/12/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import UIKit



func loadViewFromNibWithOwner<T : UIView>(_ nibName:String , _ owner:Any? = nil) -> T? {
    guard let contentView = Bundle.main.loadNibNamed(nibName, owner: owner, options: nil)?.first as? T else {
        fatalError("Cant load \(nibName).xib")
    }
    
    return contentView
}
@discardableResult
func loadViewFromNib<T : UIView>(_ nibName:String) -> T? {
    return loadViewFromNibWithOwner(nibName)
    
}

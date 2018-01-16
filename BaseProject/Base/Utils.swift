//
//  Utils.swift
//  SpectorViewParody
//
//  Created by Valeev Anatoliy on 14/11/2017.
//  Copyright © 2017 User. All rights reserved.
//

import Foundation
import UIKit

extension Set {
    func at(_ i:Int) -> Element {
        let index = self.index(self.startIndex, offsetBy: i)
        return self[index]
    }
}

extension UIViewController {
    func showAlertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        let vctrl = self
        vctrl.present(alert, animated: true, completion: nil)
    }
    
}

extension UITableViewCell {
    static var defaultReuseIdentifier: String {
        guard let substring: Substring = String(describing: self).split(separator: "<").first else {
            return String(describing: self)
        }
        return String(substring)
    }
}

extension UIView{
    
    static var stdAnimDuration:TimeInterval {return 0.33}
    static var stdAnimDelay:TimeInterval {return 0}
    static var stdAnimOptions:UIViewAnimationOptions {return UIViewAnimationOptions.curveEaseOut}
    
    static func stdAnimated (animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil){
            UIView.animate(withDuration: stdAnimDuration, delay: stdAnimDelay, options: stdAnimOptions,
                           animations: animations, completion: completion)
    }
    
    func setBorder (borderWidth: CGFloat = 1.0, borderColor: UIColor){
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
}




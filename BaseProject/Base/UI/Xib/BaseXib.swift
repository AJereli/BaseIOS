//
//  BaseXib.swift
//  BaseProject
//
//  Created by Valeev Anatoliy on 20/12/2017.
//  Copyright © 2017 Valeev A. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
             fatalError("fromNib cant loadNibNamed")
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return contentView
    }
}

class BaseXib : UIView {
    
    func loadFromXib () {
        let name = type(of: self)
        guard let contentView = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView else {
            fatalError("BaseXib cant loadFromXib")
        }
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if self.frame.isEmpty || self.frame.isInfinite {
            // If container has no frame, get it from xib view
            self.frame = contentView.frame
        } else {
            // Else update xib view with new size
            contentView.frame = self.bounds
        }
        
        self.insertSubview(contentView, at: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadFromXib()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.loadFromXib()
       
    }
    
}

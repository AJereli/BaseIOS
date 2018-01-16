//
//  TestView.swift
//  BaseProject
//
//  Created by Valeev Anatoliy on 20/12/2017.
//  Copyright © 2017 Valeev A. All rights reserved.
//

import Foundation
import UIKit

class TestView : BaseXib {
    
    @IBOutlet var textLabel: UILabel!
    
    
    private var _text:String = ""
    var text:String {
        get {return _text}
        set {
            _text = newValue
            textLabel.text = newValue
        }
        
    }
    
}

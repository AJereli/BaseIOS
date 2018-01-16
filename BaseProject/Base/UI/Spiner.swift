//
//  Spiner.swift
//  BaseProject
//
//  Created by Valeev Anatoliy on 10/01/2018.
//  Copyright © 2018 Valeev A. All rights reserved.
//

import Foundation
import UIKit

class Spiner : BaseXib {
    

    @IBOutlet var _spiner: UIActivityIndicatorView!
    

    func start (){
        _spiner.startAnimating()
    }
    func stop (){
        _spiner.stopAnimating()
    }
    

}


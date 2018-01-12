//
//  LoadingOverlay.swift
//  BaseProject
//
//  Created by Valeev Anatoliy on 11/01/2018.
//  Copyright © 2018 Valeev A. All rights reserved.
//

import Foundation
import UIKit

class LoadingOverlay : BaseOverlay {
    
    @IBOutlet var uiSpinnerContainer: UIView!
    @IBOutlet var uiSpinner: UIActivityIndicatorView!
    
    override var hideByTap: Bool {return false}
    
    init() {
        super.init(nibName: "LoadingOverlay", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func winLvl() -> UIWindowLevel {
        return UIWindowLevelStatusBar - 1
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

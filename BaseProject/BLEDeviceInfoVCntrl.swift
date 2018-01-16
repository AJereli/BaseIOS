//
//  BLEDeviceInfoVCntrl.swift
//  BaseProject
//
//  Created by Valeev Anatoliy on 15/01/2018.
//  Copyright © 2018 Valeev A. All rights reserved.
//

import Foundation
import UIKit
import BlueCapKit

class BLEDeviceInfoVCntrl : ViewCntrlBase {
    
    var peripheral:Peripheral?
    
    @IBOutlet var infoTextView: UITextView!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let peripheral = self.peripheral{
            nameLabel!.text = peripheral.name
            idLabel!.text = "\(peripheral.identifier)"
        }
        
    }
    @IBAction func connAct(_ sender: Any) {
        
        guard let p = peripheral else {return}
        
        p.connect().flatMap { _ -> Future<Void> in
            return p.discoverAllServices().andThen {
                self.infoTextView!.text = "Services cnt: \(p.services.count)\n"
                p.services.forEach({ service in
                    var str = self.infoTextView!.text + "\(service.uuid)\n"
                    service.discoverAllCharacteristics().andThen {
                        str.append("  \(service.characteristics.description)\n")
                    }
                    self.infoTextView!.text = str
                })
            }
            
        }
      
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let p = peripheral else {return}
        if p.state == .connected {
            p.disconnect()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


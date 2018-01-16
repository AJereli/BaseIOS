//
//  BLEDeviceCell.swift
//  BaseProject
//
//  Created by Valeev Anatoliy on 15/01/2018.
//  Copyright © 2018 Valeev A. All rights reserved.
//

import UIKit
import BlueCapKit

class BLEDeviceCell: UITableViewCell {

    @IBOutlet var deviceInfoLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCell(_ deviceInfo:String){
        deviceInfoLabel!.text = deviceInfo
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

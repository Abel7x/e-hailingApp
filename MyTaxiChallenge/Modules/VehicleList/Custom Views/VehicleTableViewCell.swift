//
//  VehicleTableViewCell.swift
//  MyTaxiChallenge
//
//  Created by Ricardo Abel Martinez Vivanco on 7/17/18.
//  Copyright © 2018 Ricardo Abel Martinez Vivanco. All rights reserved.
//

import UIKit

class VehicleTableViewCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    func congfigureWithVehicle(info: VehicleCellViewModel) {
        idLabel.text = info.id
        positionLabel.text = info.position
        stateLabel.text = info.state
        typeLabel.text = info.type
    }
    
}

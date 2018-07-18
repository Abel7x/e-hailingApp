//
//  VehicleTableViewCell.swift
//  MyTaxiChallenge
//
//  Created by Ricardo Abel Martinez Vivanco on 7/17/18.
//  Copyright © 2018 Ricardo Abel Martinez Vivanco. All rights reserved.
//

import UIKit

class VehicleTableViewCell: UITableViewCell {

    // MARK: - Properties & Outlets
    
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var positionLabel: UILabel!
    @IBOutlet private weak var stateLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    
    
    // MARK: - Configuration
    
    func congfigureWithVehicle(info: VehicleCellViewModel) {
        idLabel.text = info.id
        positionLabel.text = info.position
        stateLabel.text = info.state
        typeLabel.text = info.type
    }
    
}

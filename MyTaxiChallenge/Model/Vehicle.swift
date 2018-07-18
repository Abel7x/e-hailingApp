//
//  Vehicle.swift
//  MyTaxiChallenge
//
//  Created by Ricardo Abel Martinez Vivanco on 7/17/18.
//  Copyright © 2018 Ricardo Abel Martinez Vivanco. All rights reserved.
//

import Foundation

struct Vehicles: Codable {
    let poiList: [Vehicle]
}

struct Vehicle: Codable {
    let id: Double
    let coordinate: Coordinate
    let state: String
    let type: String
    let heading: Double
}

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
}

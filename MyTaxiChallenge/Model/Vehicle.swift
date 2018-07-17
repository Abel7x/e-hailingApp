//
//  Vehicle.swift
//  MyTaxiChallenge
//
//  Created by Ricardo Abel Martinez Vivanco on 7/17/18.
//  Copyright © 2018 Ricardo Abel Martinez Vivanco. All rights reserved.
//

import Foundation

/*
 {
 "poiList": [{
 "id": -479925044,
 "coordinate": {
 "latitude": 53.5530854,
 "longitude": 9.955689
 },
 "state": "INACTIVE",
 "type": "TAXI",
 "heading": 0.0
 }]
 }
 */

struct Vehicles: Codable {
    let poiList: [Vehicle]
}

struct Vehicle: Codable {
    let id: Int
    let coordinate: Coordinate
    let state: String
    let type: String
    let heading: Double
}

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
}

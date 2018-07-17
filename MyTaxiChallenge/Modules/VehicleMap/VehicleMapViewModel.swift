//
//  VehicleMapViewModel.swift
//  MyTaxiChallenge
//
//  Created by Ricardo Abel Martinez Vivanco on 7/17/18.
//  Copyright © 2018 Ricardo Abel Martinez Vivanco. All rights reserved.
//

import Foundation

class VehicleMapViewModel {
    let serviceManager: APIServiceManager
    
    private var vehicles:[Vehicle] = [Vehicle]()
    
    var reloadAnnotations: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    private var cellViewModels: [VehicleAnnotationViewModel] = [VehicleAnnotationViewModel]() {
        didSet {
            self.reloadAnnotations?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    init(serviceManager: APIServiceManager = APIServiceManager()) {
        self.serviceManager = serviceManager
    }
    
    func getVehicles(at nePoint: CLLocation, swPoint: CLLocation) {
        self.isLoading = true
        serviceManager.getVehiclesFromNePoint(nePoint, swPoint: swPoint, success:{ [weak self] (response) in
            guard let strongSelf = self  else { return }
            strongSelf.isLoading = false
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response as Any, options: JSONSerialization.WritingOptions.prettyPrinted)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let vehicles = try! decoder.decode(Vehicles.self, from: jsonData)
                strongSelf.processFetchedVehicles(vehicles: vehicles.poiList)
            } catch {
                strongSelf.alertMessage = "Unexpected Error"
            }
        }) { [weak self] (error, errorCode) in
            guard let strongSelf = self else { return }
            strongSelf.alertMessage = error
        }
    }

    
    func createAnnotationViewModel(vehicle: Vehicle) -> VehicleAnnotationViewModel {
        return VehicleAnnotationViewModel(id: "\(vehicle.id)",
            lat: vehicle.coordinate.latitude,
            lon: vehicle.coordinate.longitude,
            heading: vehicle.heading,
            type: vehicle.type,
            state: vehicle.state)
    }
    
    private func processFetchedVehicles(vehicles: [Vehicle]) {
        self.vehicles = vehicles
        var viewModels = [VehicleAnnotationViewModel]()
        for vehicle in vehicles {
            viewModels.append(createAnnotationViewModel(vehicle: vehicle))
        }
        cellViewModels = viewModels
    }
    
    func getVehicleAnnotationViewModels() -> [VehicleAnnotationViewModel] {
        return cellViewModels
    }
}

struct VehicleAnnotationViewModel {
    let id: String
    let lat: Double
    let lon: Double
    let heading: Double
    let type: String
    let state: String
}

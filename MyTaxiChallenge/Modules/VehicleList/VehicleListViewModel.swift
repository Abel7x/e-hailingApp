//
//  VehicleListViewModel.swift
//  MyTaxiChallenge
//
//  Created by Ricardo Abel Martinez Vivanco on 7/17/18.
//  Copyright © 2018 Ricardo Abel Martinez Vivanco. All rights reserved.
//

import Foundation

class VehicleListViewModel {
    
    let serviceManager: APIServiceManager
    
    private var vehicles:[Vehicle] = [Vehicle]()
    
    var reloadTableViewClosure: (()->())?
    var showAlertClosure: (()->())?
    var updateLoadingStatus: (()->())?
    
    private var cellViewModels: [VehicleCellViewModel] = [VehicleCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
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
    
    func getVehicles() {
        self.isLoading = true
        serviceManager.getVehiclesFromNePoint({ [weak self] (response) in
            guard let strongSelf = self  else { return }
            strongSelf.isLoading = false
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
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
    
    func getCellViewModel(at indexPath: IndexPath) -> VehicleCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel(vehicle: Vehicle) -> VehicleCellViewModel {
        let lat = String(format: "Lat: %.4f", vehicle.coordinate.latitude)
        let lon = String(format: "Lon: %.4f", vehicle.coordinate.longitude)
        let direction = String(format: "Heading: %.4f", vehicle.heading)
        
        return VehicleCellViewModel(id: "\(vehicle.id)",
                                    position: lat + "\n" + lon + "\n" + direction,
                                    type: vehicle.type,
                                    state: vehicle.state)
    }
    
    private func processFetchedVehicles(vehicles: [Vehicle]) {
        self.vehicles = vehicles
        var viewModels = [VehicleCellViewModel]()
        for vehicle in vehicles {
            viewModels.append(createCellViewModel(vehicle: vehicle))
        }
        cellViewModels = viewModels
    }
}


struct VehicleCellViewModel {
    let id: String
    let position: String
    let type: String
    let state: String
}

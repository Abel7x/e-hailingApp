//
//  VehicleListViewModel.swift
//  MyTaxiChallenge
//
//  Created by Ricardo Abel Martinez Vivanco on 7/17/18.
//  Copyright © 2018 Ricardo Abel Martinez Vivanco. All rights reserved.
//

import Foundation

class VehicleListViewModel {
    
    // MARK: - Properties & Outlets
    
    let serviceManager: APIServiceManager
    let baseServiceParser: BaseServiceParser
    
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
    
    // MARK: - Inits
    
    init(serviceManager: APIServiceManager = APIServiceManager(), baseParser: BaseServiceParser = BaseServiceParser()) {
        self.serviceManager = serviceManager
        self.baseServiceParser = baseParser
    }
    
    // MARK: - Public Methods
    
    func getVehicles() {
        self.isLoading = true
        serviceManager.getVehiclesFromNePoint({ [weak self] (response) in
            guard let strongSelf = self  else { return }
            strongSelf.isLoading = false
            guard let vehicles = strongSelf.baseServiceParser.parseResponse(response: response as Any, type: Vehicles.self) else {
                strongSelf.alertMessage = "Unexpected Error"
                return
            }
            strongSelf.processFetchedVehicles(vehicles: vehicles.poiList)
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
    
    // MARK: - Private Methods
    
    private func processFetchedVehicles(vehicles: [Vehicle]) {
        self.vehicles = vehicles
        var viewModels = [VehicleCellViewModel]()
        for vehicle in vehicles {
            viewModels.append(createCellViewModel(vehicle: vehicle))
        }
        cellViewModels = viewModels
    }
}

// MARK: - VehicleCellViewModel Declaration

struct VehicleCellViewModel {
    let id: String
    let position: String
    let type: String
    let state: String
}

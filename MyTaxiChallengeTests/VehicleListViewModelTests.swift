//
//  VehicleListViewModelTests.swift
//  MyTaxiChallengeTests
//
//  Created by Ricardo Abel Martinez Vivanco on 7/18/18.
//  Copyright © 2018 Ricardo Abel Martinez Vivanco. All rights reserved.
//

import XCTest
@testable import MyTaxiChallenge

class VehicleListViewModelTests: XCTestCase {
    
    var viewModel: VehicleListViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = VehicleListViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testLoadingWhenFetching() {
        
        var loadingStatus = false
        let expect = XCTestExpectation(description: "Loading status updated")
        viewModel.updateLoadingStatus = { [weak viewModel] in
            loadingStatus = viewModel!.isLoading
            expect.fulfill()
        }
        
        //when fetching
        viewModel.getVehicles()
        
        // Assert
        XCTAssertTrue( loadingStatus )
        
        wait(for: [expect], timeout: 1.0)
    }
    
    func testCreateCellViewModel() {
        
        let vehicles = StubGenerator().stubVehicles()
        let vehicle = vehicles[0]
        
        let vehicleCellViewModel = viewModel.createCellViewModel(vehicle: vehicle)
        
        //Assert
        XCTAssertEqual( String(vehicle.id), vehicleCellViewModel.id)
        XCTAssertNotNil(vehicle.state, vehicleCellViewModel.state)
    }
}

class StubGenerator {
    func stubVehicles() -> [Vehicle] {
        let path = Bundle.main.path(forResource: "content", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let vehicles = try! decoder.decode(Vehicles.self, from: data)
        return vehicles.poiList
    }
}


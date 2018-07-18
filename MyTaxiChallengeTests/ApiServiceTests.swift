//
//  ApiServiceTests.swift
//  MyTaxiChallengeTests
//
//  Created by Ricardo Abel Martinez Vivanco on 7/18/18.
//  Copyright © 2018 Ricardo Abel Martinez Vivanco. All rights reserved.
//

import XCTest
@testable import MyTaxiChallenge

class ApiServiceTests: XCTestCase {
    
    var serviceManager: APIServiceManager?
    var baseParser: BaseServiceParser?
    
    override func setUp() {
        super.setUp()
        serviceManager = APIServiceManager()
        baseParser = BaseServiceParser()
    }
    
    override func tearDown() {
        serviceManager = nil
        baseParser = nil
        super.tearDown()
    }
    
    func testFetchVehiclesSuccess() {
        
        let serviceManager = self.serviceManager!
        
        let expect = XCTestExpectation(description: "completion")
        
        serviceManager.getVehiclesFromNePoint({ (response) in
            expect.fulfill()
            XCTAssertNotNil(response)
        }) { (error, errorCode) in
            XCTFail(error!)
        }
        
        wait(for: [expect], timeout: 3.0)
    }
    
    func testParseVehicles() {
        let serviceManager = self.serviceManager!
        
        let expect = XCTestExpectation(description: "completion")
        
        serviceManager.getVehiclesFromNePoint({ [weak self] (response) in
            guard let strongSelf = self else { return }
            expect.fulfill()
            guard let vehicles = strongSelf.baseParser?.parseResponse(response: response as Any, type: Vehicles.self) else {
                XCTFail("Parse Failed")
                return
            }
            XCTAssertNotNil(vehicles)
            
        }) { (error, errorCode) in
            XCTFail(error!)
        }
        wait(for: [expect], timeout: 3.0)
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

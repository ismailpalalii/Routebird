//
//  LocationServiceTests.swift
//  Routebird
//
//  Created by İsmail Palalı on 12.06.2025.
//

import XCTest
@testable import Routebird
import CoreLocation

final class LocationServiceTests: XCTestCase {
    
    func testStartTrackingCalled() {
        let mockService = MockLocationService()
        mockService.startTracking()
        XCTAssertTrue(mockService.startTrackingCalled)
    }
    
    func testStopTrackingCalled() {
        let mockService = MockLocationService()
        mockService.stopTracking()
        XCTAssertTrue(mockService.stopTrackingCalled)
    }
    
    func testDelegateReceivesLocationUpdate() {
        class DelegateMock: LocationServiceDelegate {
            var locationUpdateReceived = false
            func locationService(_ service: LocationService, didUpdateLocation location: CLLocation) {
                locationUpdateReceived = true
            }
        }
        
        let service = LocationService()
        let delegateMock = DelegateMock()
        service.delegate = delegateMock
        
        let testLocation = CLLocation(latitude: 37.0, longitude: 27.0)
        service.simulateLocationUpdate(testLocation)
        
        XCTAssertTrue(delegateMock.locationUpdateReceived)
    }
}

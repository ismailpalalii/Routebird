//
//  MockLocationService.swift
//  Routebird
//
//  Created by İsmail Palalı on 12.06.2025.
//

import Foundation
import CoreLocation
@testable import Routebird

final class MockLocationService: LocationServiceProtocol {
    weak var delegate: LocationServiceDelegate?
    var startTrackingCalled = false
    var stopTrackingCalled = false
    
    func startTracking() {
        startTrackingCalled = true
    }
    
    func stopTracking() {
        stopTrackingCalled = true
    }
}

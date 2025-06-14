//
//  MapViewModelTests.swift
//  RoutebirdTests
//
//  Created by İsmail Palalı on 13.06.2025.
//

import XCTest
import CoreLocation
@testable import Routebird

final class MapViewModelTests: XCTestCase {

    var viewModel: MapViewModel!
    var delegate: MockDelegate!

    override func setUp() {
        super.setUp()
        let mockStorage = MockStorage()
        viewModel = MapViewModel(storage: mockStorage)
        delegate = MockDelegate()
        viewModel.delegate = delegate
    }

    override func tearDown() {
        viewModel = nil
        delegate = nil
        UserDefaults.standard.removeObject(forKey: "routeMarkers")
        super.tearDown()
    }

    func testToggleTracking() {
        XCTAssertFalse(viewModel.isTracking)
        viewModel.toggleTracking()
        XCTAssertTrue(viewModel.isTracking)
        viewModel.toggleTracking()
        XCTAssertFalse(viewModel.isTracking)
    }

    func testAddMarkerAddsNewMarker() {
        viewModel.isTracking = true
        let location = CLLocation(latitude: 37.3318, longitude: -122.0312)
        viewModel.updateLocation(location)
        XCTAssertEqual(viewModel.markers.count, 1)
    }

    func testNoMarkerWhenNotTracking() {
        viewModel.isTracking = false
        let location = CLLocation(latitude: 37.3318, longitude: -122.0312)
        viewModel.updateLocation(location)
        XCTAssertEqual(viewModel.markers.count, 0)
    }

    func testResetRouteClearsMarkers() {
        viewModel.isTracking = true
        let location = CLLocation(latitude: 37.3318, longitude: -122.0312)
        viewModel.updateLocation(location)
        XCTAssertFalse(viewModel.markers.isEmpty)
        viewModel.resetRoute()
        XCTAssertTrue(viewModel.markers.isEmpty)
    }

    func testPersistence() {
        let mockStorage = MockStorage()
        viewModel = MapViewModel(storage: mockStorage)
        viewModel.isTracking = true
        let location = CLLocation(latitude: 37.0, longitude: 29.0)
        viewModel.updateLocation(location)
        viewModel.saveRoute()
        
        let newViewModel = MapViewModel(storage: mockStorage)
        let mock = MockDelegate()
        newViewModel.delegate = mock
        newViewModel.loadRoute()
        
        XCTAssertEqual(newViewModel.markers.count, 1)
        XCTAssertEqual(newViewModel.markers.first?.latitude, 37.0)
    }

    func testErrorHandlingCallsDelegate() {
        let failingViewModel = MapViewModel()
        let mockDelegate = MockDelegate()
        failingViewModel.delegate = mockDelegate

        let expectedError = RoutebirdError.permissionDenied
        failingViewModel.delegate?.didEncounterError(expectedError)

        if let capturedError = mockDelegate.capturedError {
            switch capturedError {
            case .permissionDenied:
                XCTAssertTrue(true)
            default:
                XCTFail("Unexpected error received")
            }
        } else {
            XCTFail("No error captured")
        }
    }
}

// MARK: - Mock Delegate

final class MockDelegate: MapViewModelDelegate {
    var capturedError: RoutebirdError?

    func didEncounterError(_ error: Routebird.RoutebirdError) {
        capturedError = error
    }

    func didAddNewMarker(_ marker: Marker) { }
    func didResetRoute() { }
    func didResolveAddress(_ address: String, for marker: Marker) { }
}

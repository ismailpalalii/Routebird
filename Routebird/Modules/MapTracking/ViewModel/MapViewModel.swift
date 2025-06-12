//
//  MapViewModel.swift
//  Routebird
//
//  Created by İsmail Palalı on 12.06.2025.
//


import Foundation
import CoreLocation

// MARK: - Marker Model
struct Marker: Equatable {
    let id: UUID
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let timestamp: Date
    var address: String? = nil

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(coordinate: CLLocationCoordinate2D) {
        self.id = UUID()
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.timestamp = Date()
    }
}

protocol MapViewModelDelegate: AnyObject {
    func didAddNewMarker(_ marker: Marker)
    func didResetRoute()
    func didResolveAddress(_ address: String, for marker: Marker)
}

final class MapViewModel {

    // MARK: - Properties

    weak var delegate: MapViewModelDelegate?

    private(set) var markers: [Marker] = []
    var isTracking = false
    private var lastRecordedLocation: CLLocation?

    private let geocoder = CLGeocoder()

    // MARK: - Tracking Control

    func toggleTracking() {
        isTracking.toggle()
    }

    func resetRoute() {
        markers.removeAll()
        lastRecordedLocation = nil
        delegate?.didResetRoute()
    }

    // MARK: - Location Handling

    func updateLocation(_ location: CLLocation) {
        guard isTracking else { return }
        if let last = lastRecordedLocation {
            let distance = location.distance(from: last)
            if distance >= 100 {
                addMarker(for: location)
            }
        } else {
            addMarker(for: location)
        }
    }

    func resolveAddress(for marker: Marker) {
        let location = CLLocation(latitude: marker.latitude, longitude: marker.longitude)
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            guard let self = self else { return }
            let name = placemarks?.first?.name ?? "No address found"
            self.delegate?.didResolveAddress(name, for: marker)
        }
    }

    // MARK: - Private Marker Logic

    private func addMarker(for location: CLLocation) {
        lastRecordedLocation = location
        let marker = Marker(coordinate: location.coordinate)
        markers.append(marker)
        delegate?.didAddNewMarker(marker)
    }
}

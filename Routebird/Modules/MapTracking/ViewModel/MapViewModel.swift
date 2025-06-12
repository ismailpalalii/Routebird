//
//  MapViewModel.swift
//  Routebird
//
//  Created by İsmail Palalı on 12.06.2025.
//


import Foundation
import CoreLocation

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
    private let routeKey = "routeMarkers"

    // MARK: - Tracking Control

    func toggleTracking() {
        isTracking.toggle()
    }

    func resetRoute() {
        markers.removeAll()
        lastRecordedLocation = nil
        delegate?.didResetRoute()
        saveRoute()
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

    // MARK: - Marker Logic

    private func addMarker(for location: CLLocation) {
        lastRecordedLocation = location
        let marker = Marker(coordinate: location.coordinate)
        markers.append(marker)
        delegate?.didAddNewMarker(marker)
        saveRoute()
    }

    // MARK: - Reverse Geocoding

    func resolveAddress(for marker: Marker) {
        let location = CLLocation(latitude: marker.latitude, longitude: marker.longitude)
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            guard let self = self else { return }
            let name = placemarks?.first?.name ?? "No address found"
            self.delegate?.didResolveAddress(name, for: marker)
        }
    }
    
    // MARK: - Speed Calculation

       func getCurrentSpeedKmh() -> Double? {
           guard markers.count >= 2 else { return nil }
           let last = markers[markers.count - 1]
           let prev = markers[markers.count - 2]
           let lastLoc = CLLocation(latitude: last.latitude, longitude: last.longitude)
           let prevLoc = CLLocation(latitude: prev.latitude, longitude: prev.longitude)
           let distance = lastLoc.distance(from: prevLoc) // metre
           let timeDiff = last.timestamp.timeIntervalSince(prev.timestamp)
           guard timeDiff > 0 else { return nil }
           let speedMs = distance / timeDiff
           let speedKmh = speedMs * 3.6
           return speedKmh
       }

    // MARK: - Persistence

    func saveRoute() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(markers) {
            print("💾 Saving \(markers.count) markers")
            UserDefaults.standard.set(data, forKey: routeKey)
        } else {
            print("❌ Failed to encode markers")
        }
    }
    func loadRoute() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: routeKey),
           let savedMarkers = try? decoder.decode([Marker].self, from: data) {
            print("📥 Loaded \(savedMarkers.count) markers")
            markers = savedMarkers
            delegate?.didResetRoute()
            for marker in markers {
                delegate?.didAddNewMarker(marker)
            }
            if let last = markers.last {
                let loc = CLLocation(latitude: last.latitude, longitude: last.longitude)
                lastRecordedLocation = loc
            }
        } else {
            print("📭 No saved markers found in UserDefaults")
        }
    }
}

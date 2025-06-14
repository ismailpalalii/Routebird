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
    func didEncounterError(_ error: RoutebirdError)
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
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }

            guard error == nil, let placemark = placemarks?.first else {
                self.delegate?.didResolveAddress("📍 " + "marker_address_error".localized, for: marker)
                return
            }

            let shortAddress = [placemark.thoroughfare,
                                placemark.subThoroughfare,
                                placemark.locality]
                .compactMap { $0 }
                .joined(separator: ", ")

            var updatedMarker = marker
            updatedMarker.address = shortAddress

            if let index = self.markers.firstIndex(where: { $0.id == marker.id }) {
                self.markers[index] = updatedMarker
            }

            self.delegate?.didResolveAddress(shortAddress, for: updatedMarker)
            self.saveRoute()
        }
    }
    // MARK: - Speed Calculation

    func getCurrentSpeedKmh() -> Double? {
        guard markers.count >= 2 else { return nil }
        let last = markers[markers.count - 1]
        let prev = markers[markers.count - 2]
        let lastLoc = CLLocation(latitude: last.latitude, longitude: last.longitude)
        let prevLoc = CLLocation(latitude: prev.latitude, longitude: prev.longitude)
        let distance = lastLoc.distance(from: prevLoc)
        let timeDiff = last.timestamp.timeIntervalSince(prev.timestamp)
        guard timeDiff > 0 else { return nil }
        return (distance / timeDiff) * 3.6
    }

    // MARK: - Persistence

    func saveRoute() {
        if markers.isEmpty {
            UserDefaults.standard.removeObject(forKey: routeKey)
            return
        }

        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(markers)
            UserDefaults.standard.set(data, forKey: routeKey)
        } catch {
            print("❌ Encoding error: \(error.localizedDescription)")
            delegate?.didEncounterError(.encodingFailed)
        }
    }

    func loadRoute() {
        guard let data = UserDefaults.standard.data(forKey: routeKey) else {
            print("📭 No saved markers found in UserDefaults")
            return
        }

        let decoder = JSONDecoder()
        do {
            let savedMarkers = try decoder.decode([Marker].self, from: data)
            markers = savedMarkers
            delegate?.didResetRoute()
            for marker in markers {
                delegate?.didAddNewMarker(marker)
            }
            if let last = markers.last {
                let loc = CLLocation(latitude: last.latitude, longitude: last.longitude)
                lastRecordedLocation = loc
            }
        } catch {
            print("❌ Decoding error: \(error.localizedDescription)")
            delegate?.didEncounterError(.decodingFailed)
        }
    }
}

//
//  Marker.swift
//  Routebird
//
//  Created by İsmail Palalı on 12.06.2025.
//


import Foundation
import CoreLocation

struct Marker: Equatable, Codable {
    let id: UUID
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let timestamp: Date
    var address: String?

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(coordinate: CLLocationCoordinate2D, timestamp: Date = Date(), address: String? = nil) {
        self.id = UUID()
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.timestamp = timestamp
        self.address = address
    }
}
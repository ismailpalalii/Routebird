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

    var title: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let time = formatter.string(from: timestamp)
        return String(format: NSLocalizedString("marker_title", comment: ""), time)
    }

    var subtitle: String? {
        if let address = address, !address.isEmpty {
            return address
        } else {
            return String(format: NSLocalizedString("marker_coordinates", comment: ""), latitude, longitude)
        }
    }
    
    init(coordinate: CLLocationCoordinate2D, timestamp: Date = Date(), address: String? = nil) {
        self.id = UUID()
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.timestamp = timestamp
        self.address = address
    }
}

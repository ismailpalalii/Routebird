//
//  MockStorage.swift
//  Routebird
//
//  Created by İsmail Palalı on 15.06.2025.
//

@testable import Routebird

final class MockStorage: MarkerStorageProtocol {
    var savedMarkers: [Marker] = []

    func saveMarker(_ marker: Marker) throws {
        savedMarkers.append(marker)
    }

    func fetchMarkers() throws -> [Marker] {
        return savedMarkers
    }

    func deleteAllMarkers() throws {
        savedMarkers.removeAll()
    }
}

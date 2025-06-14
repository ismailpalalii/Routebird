//
//  MarkerStorage.swift
//  Routebird
//
//  Created by İsmail Palalı on 15.06.2025.
//

import Foundation
import CoreData
import CoreLocation

protocol MarkerStorageProtocol {
    func saveMarker(_ marker: Marker) throws
    func fetchMarkers() throws -> [Marker]
    func deleteAllMarkers() throws
}

final class MarkerStorage: MarkerStorageProtocol {
    
    private let context = CoreDataStack.shared.context

    // MARK: - Save

    func saveMarker(_ marker: Marker) throws {
        let entity = MarkerEntity(context: context)
        entity.id = marker.id
        entity.latitude = marker.latitude
        entity.longitude = marker.longitude
        entity.timestamp = marker.timestamp
        entity.address = marker.address
        try CoreDataStack.shared.saveContext()
    }

    // MARK: - Fetch

    func fetchMarkers() throws -> [Marker] {
        let request: NSFetchRequest<MarkerEntity> = MarkerEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        do {
            let entities = try context.fetch(request)
            return entities.map {
                Marker(
                    coordinate: CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude),
                    timestamp: $0.timestamp ?? Date(),
                    address: $0.address
                )
            }
        } catch {
            throw RoutebirdError.decodingFailed
        }
    }

    // MARK: - Delete All

    func deleteAllMarkers() throws {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MarkerEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            try CoreDataStack.shared.saveContext()
        } catch {
            throw RoutebirdError.coreDataDeletionFailed
        }
    }
}

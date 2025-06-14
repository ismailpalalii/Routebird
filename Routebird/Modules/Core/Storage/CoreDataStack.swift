//
//  CoreDataStack.swift
//  Routebird
//
//  Created by İsmail Palalı on 15.06.2025.
//


import Foundation
import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MarkerEntity")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ Unresolved Core Data error: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ Core Data save error: \(error.localizedDescription)")
                throw RoutebirdError.coreDataSaveFailed(error)
            }
        }
    }
}

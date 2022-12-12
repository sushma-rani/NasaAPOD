//
//  TestCoreDataStack.swift
//  NasaAPODTests
//
//  Created by Shivakumar, Sushma on 12/12/22.
//

import Foundation
import CoreData
@testable import NasaAPOD

class TestCoreDataStack: NSObject {
    let persistentContainer: NSPersistentContainer
    let mainContext: NSManagedObjectContext
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "NasaAPOD")
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
        }
        
        mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.automaticallyMergesChangesFromParent = true
        mainContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
    }
}

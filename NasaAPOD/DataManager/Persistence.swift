//
//  Persistence.swift
//  NasaAPOD
//
//  Created by Shivakumar, Sushma on 09/12/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "NasaAPOD")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    /// Query and return first found object for the given entity and predicate
    /// - Parameter entityName: Entity name in dataModel
    /// - Parameter predicate: predicate to query the entity
    /// - Parameter sortedBy: sorted by query string
    /// - Parameter ascending: sort order
    /// - Parameter managedObjectContext: Managed object context
    /// - Returns  return first found managed object for the given entity and predicate
    func singleObjectInContext(_ entityName: String,
                               predicate: NSPredicate?,
                               sortedBy: String?,
                               ascending: Bool,
                               managedObjectContext: NSManagedObjectContext? = nil) -> NSManagedObject? {
        do {
            let results = try objectsInContext(entityName,
                                               predicate: predicate,
                                               sortedBy: sortedBy,
                                               ascending: ascending,
                                               managedObjectContext: managedObjectContext)
            guard !results.isEmpty else {
                return nil
            }
            return results.first
        } catch {
            debugPrint("Error retrieving single core data object: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Query and return objects for the given entity and predicate
    /// - Parameter entityName: Entity name in dataModel
    /// - Parameter predicate: predicate to query the entity
    /// - Parameter sortedBy: sorted by query string
    /// - Parameter ascending: sort order
    /// - Parameter managedObjectContext: Managed object context
    /// - Returns  return  found managed objects for the given entity and predicate
    func objectsInContext(_ entityName: String,
                          predicate: NSPredicate?,
                          sortedBy: String?,
                          ascending: Bool,
                          managedObjectContext: NSManagedObjectContext? = nil) throws -> [NSManagedObject] {
        var request: NSFetchRequest<NSFetchRequestResult>?
        var evaluatedManagedObjectContext: NSManagedObjectContext?
        
        if let managedObjContextParameter: NSManagedObjectContext = managedObjectContext {
            evaluatedManagedObjectContext = managedObjContextParameter
            request = fetchRequest(entityName,
                                   context: managedObjContextParameter,
                                   predicate: predicate,
                                   sortedBy: sortedBy,
                                   ascending: ascending)
        } else {
            evaluatedManagedObjectContext = container.viewContext
            if let moc = evaluatedManagedObjectContext {
                request = fetchRequest(entityName,
                                       context: moc,
                                       predicate: predicate,
                                       sortedBy: sortedBy,
                                       ascending: ascending)
            }
        }
        
        if let fetchRequest = request {
            guard let results = try evaluatedManagedObjectContext?.fetch(fetchRequest) as? [NSManagedObject] else {
                return []
            }
            return results
        } else {
            return []
        }
    }
    
    /// Query and return total count of objects for the given entity and predicate
    /// - Parameter entityName: Entity name in dataModel
    /// - Parameter predicate: predicate to query the entity
    /// - Returns  return  total count of objects for the given entity and predicate
    func countOfObjects(_ entityName: String, predicate: NSPredicate?) throws -> Int {
        let request = fetchRequest(entityName, context: container.viewContext, predicate: predicate)
        let count: Int
        do {
            count = try container.viewContext.count(for: request)
        } catch let error as NSError {
            print("Error retrieving count for data: \(error.localizedDescription)")
            return 0
        }
        
        return count
    }
    
    /// Forms the fetch request for the given entity and predicate
    /// - Parameter entityName: Entity name in dataModel
    /// - Parameter managedObjectContext: Managed object context
    /// - Parameter predicate: predicate to query the entity
    /// - Returns  return fetch request for the given entity and predicate
    func fetchRequest(_ entityName: String, context: NSManagedObjectContext, predicate: NSPredicate? = nil, sortedBy: String? = nil, ascending: Bool = false) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        fetchRequest.entity = entity
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        
        if let sort = sortedBy {
            let sortDescriptor = NSSortDescriptor(key: sort, ascending: ascending)
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        
        return fetchRequest
    }
}

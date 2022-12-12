//
//  NasaAPODDataManager.swift
//  NasaAPOD
//
//  Created by Shivakumar, Sushma on 11/12/22.
//

import Foundation
import SwiftUI

class NasaAPODDataManager {
    static let shared = NasaAPODDataManager()
    
    private init() {}
    
    /// Add Picture of the day data to Core data
    /// - Parameter APODModel: APOD model
    /// - Parameter image: UIImage of downloaded image of the day
    /// - Parameter persistenceManager: PersistenceController
    func addAPODData(APODModel: APOD,
                     image: UIImage,
                     persistenceManager: PersistenceController = PersistenceController.shared) {
        let count = try? persistenceManager.countOfObjects("ManagedAPOD", predicate:  NSPredicate(
            format: "picDate LIKE %@", APODModel.date
        ))
        if count == 0 {
            let moc = persistenceManager.container.viewContext
            let managedAPOD = ManagedAPOD(context: moc)
            managedAPOD.picDate = APODModel.date
            managedAPOD.url = APODModel.url
            managedAPOD.mediaType = APODModel.mediaType
            managedAPOD.message = APODModel.explanation
            managedAPOD.title = APODModel.title
            managedAPOD.isFav = false
            let jpegImageData = image.jpegData(compressionQuality: 1.0)
            managedAPOD.setValue(jpegImageData, forKeyPath: "imageData")
            do {
                try persistenceManager.container.viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    /// Favourite/UnFavourite the Picture of the day data
    /// - Parameter day: date string value
    /// - Parameter favourite: favourite/Unfavourite bool value
    /// - Parameter persistenceManager: PersistenceController
    /// - Returns  Boolean value which represents success of favourite/unFavourite operation
    func favouritePic(day: String,
                      favourite: Bool,
                      persistenceManager: PersistenceController = PersistenceController.shared) -> Bool {
        let existingItem = persistenceManager.singleObjectInContext("ManagedAPOD", predicate: NSPredicate(
            format: "picDate LIKE %@", day
        ), sortedBy: nil, ascending: true)
        guard let itemToUpdate = existingItem as? ManagedAPOD else {
            return false
        }
        itemToUpdate.isFav = favourite
        try? persistenceManager.container.viewContext.save()
        return true
    }
    
    /// Check whether the Picture of the provide day is favourite or not
    /// - Parameter day: date string value
    /// - Parameter persistenceManager: PersistenceController
    /// - Returns  Boolean value which represents picture is favourite or not
    func isPicFavourite(day: String,
                        persistenceManager: PersistenceController = PersistenceController.shared)  -> Bool {
        let existingItem = persistenceManager.singleObjectInContext("ManagedAPOD", predicate: NSPredicate(
            format: "picDate LIKE %@", day
        ), sortedBy: nil, ascending: true)
        guard let item = existingItem as? ManagedAPOD else {
            return false
        }
        return item.isFav
    }
}
            
      
            

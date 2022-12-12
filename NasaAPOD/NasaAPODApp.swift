//
//  NasaAPODApp.swift
//  NasaAPOD
//
//  Created by Shivakumar, Sushma on 09/12/22.
//

import SwiftUI

@main
struct NasaAPODApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

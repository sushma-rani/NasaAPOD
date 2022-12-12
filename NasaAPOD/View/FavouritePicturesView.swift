//
//  FavouritePicturesView.swift
//  NasaAPOD
//
//  Created by Shivakumar, Sushma on 12/12/22.
//

import Foundation
import SwiftUI

struct FavouritePicturesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ManagedAPOD.picDate, ascending: false)],
        predicate: NSPredicate(
            format: "isFav == %@", NSNumber(value: true)
        ),
        animation: .default)
    private var items: FetchedResults<ManagedAPOD>
    
    var body: some View {
        List {
            if items.isEmpty {
                Text("No Favourite pictures yet!!")
                    .font(.headline)
            } else {
                ForEach(items) { item in
                    VStack(alignment: .leading) {
                        Text(item.title ?? "")
                            .font(.headline)
                        Text(item.picDate ?? "")
                            .font(.subheadline)
                    }
                }
            }
        }
        .navigationTitle("Favourites")
    }
}

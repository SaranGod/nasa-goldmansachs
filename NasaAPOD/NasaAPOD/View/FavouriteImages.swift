//
//  FavouriteImages.swift
//  NasaAPOD
//
//  Created by Saran on 4/17/22.
//

import SwiftUI

struct FavouriteImages: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "isFavourite == 1"),
        animation: .default
    )
    private var items: FetchedResults<NasaApodImage>
    
    var body: some View {
        List {
            ForEach(items) { item in
                NavigationLink {
                    APODImageView(dateToSearch: item.date ?? "")
                        .environment(\.managedObjectContext, viewContext)
                } label: {
                    Text(item.date ?? "")
                }
            }
            .onDelete(perform: deleteItems)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        Text("Select an item")
            .navigationTitle("Favourites")
            .navigationBarTitleDisplayMode(.large)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach({$0.isFavourite = false})

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct FavouriteImages_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteImages()
    }
}

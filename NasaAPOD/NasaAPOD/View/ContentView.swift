//
//  ContentView.swift
//  NasaAPOD
//
//  Created by Saran on 4/15/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var items: FetchedResults<NasaApodImage>
    
    @State var dateString = ""
    
    var body: some View {
        NavigationView{
            List{
                NavigationLink(destination: APODImageView(dateToSearch: self.dateString)
                                .environment(\.managedObjectContext, viewContext)){
                    Text("Get Today's Image")
                }
                NavigationLink(destination: APODImageByDate()
                                .environment(\.managedObjectContext, viewContext)){
                    Text("Search Image By Date")
                }
                NavigationLink(destination: FavouriteImages()
                                .environment(\.managedObjectContext, viewContext)){
                    Text("Favourites")
                }
            }
            .navigationTitle("Pic of the day by NASA")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.dateString = dateFormatter.string(from: Date())
        }
    }

//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
//    }

    private func addItem() {
        withAnimation {
            let newItem = NasaApodImage(context: viewContext)
//            newItem.timestamp = Date()

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

//
//  NasaAPODApp.swift
//  NasaAPOD
//
//  Created by Quin Design on 4/15/22.
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

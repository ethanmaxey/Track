//
//  TrackApp.swift
//  Track
//
//  Created by Ethan Maxey on 8/31/24.
//

import SwiftUI

@main
struct TrackApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

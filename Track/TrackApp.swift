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
    let viewModel = ViewModel(context: PersistenceController.shared.container.viewContext)
    
    @State var networkMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(viewModel)
                .environment(networkMonitor)
        }
    }
}

//
//  TrackApp.swift
//  Track
//
//  Created by Ethan Maxey on 8/31/24.
//

import SwiftUI
import TipKit

@main
struct TrackApp: App {
    let persistenceController = PersistenceController.shared
    let viewModel = ViewModel(viewContext: PersistenceController.shared.container.viewContext)

    init() {
        try? Tips.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(viewModel)
        }
    }
}

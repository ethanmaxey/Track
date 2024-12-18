//
//  TrackApp.swift
//  Track
//
//  Created by Ethan Maxey on 8/31/24.
//

import SwiftRater
import SwiftUI
import TipKit

@main
struct TrackApp: App {
    let persistenceController = PersistenceController.shared
    let viewModel = ViewModel(viewContext: PersistenceController.shared.container.viewContext)

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        SwiftRater.daysUntilPrompt = 7
        SwiftRater.usesUntilPrompt = 10
        SwiftRater.significantUsesUntilPrompt = 3
        SwiftRater.daysBeforeReminding = 1
        SwiftRater.showLaterButton = true
        SwiftRater.debugMode = false
        SwiftRater.appLaunched()
        return true
    }
}

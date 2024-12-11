//
//  ContentView.swift
//  Track
//
//  Created by Ethan Maxey on 12/8/24.
//

import SwiftUI

struct ContentView: View {    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Track", systemImage: "house")
                }
                .tag(0)
            
            SankeyView()
                .tabItem {
                    Label("Visualize", systemImage: "chart.xyaxis.line")
                }
                .tag(1)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
    }
}

#Preview("Light") {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(ViewModel.preview)
}

#Preview("Dark") {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(ViewModel.preview)
        .preferredColorScheme(.dark)
}

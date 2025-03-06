//
//  ContentView.swift
//  Track
//
//  Created by Ethan Maxey on 12/8/24.
//

import SwiftUI

struct ContentView: View {    
    var body: some View {
        
            if UIDevice.current.userInterfaceIdiom == .phone {
                TabView {
                    HomeView()
                        .tabItem {
                            Label(L10n.track, systemImage: "house")
                        }
                        .tag(0)
                    
                    SankeyView()
                        .tabItem {
                            Label(L10n.visualize, systemImage: "chart.xyaxis.line")
                                .accessibilityIdentifier("Visualize Tab")
                        }
                        .tag(1)
                    
                    SettingsView()
                        .tabItem {
                            Label(L10n.settings, systemImage: "gear")
                        }
                        .tag(2)
                }
            } else {
                TabView {
                    HomeView()
                        .tabItem {
                            Label(L10n.jobs, systemImage: "house")
                        }
                        .tag(0)
                    
                    SettingsView()
                        .tabItem {
                            Label(L10n.settings, systemImage: "gear")
                        }
                        .tag(2)
                }
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

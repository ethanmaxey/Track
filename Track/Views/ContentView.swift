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
            
            SankeyView()
                .tabItem {
                    Label("Visualize", systemImage: "chart.xyaxis.line")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

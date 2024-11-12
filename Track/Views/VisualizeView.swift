//
//  VisualizeView.swift
//  Track
//
//  Created by Ethan Maxey on 9/3/24.
//

import Sankey
import SwiftUI

struct VisualizeView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(NetworkMonitor.self) private var networkMonitor: NetworkMonitor

    @State var data: [SankeyLink] = [
        ["Applications", "Interviews", "4"],
        ["Applications", "Rejected", "9"],
        ["Applications", "No Answer", "4"],
        ["Interviews", "Offers", "2"],
        ["Interviews", "No Offer", "2"],
        ["Offers", "Accepted", "1"],
        ["Offers", "Declined", "1"]
    ]
    
    let colors = [
        "#a6cee3", "#b2df8a", "#fb9a99", "#fdbf6f",
        "#cab2d6", "#ffff99", "#1f78b4", "#33a02c"
    ]
    
    // Changing this will force an update on SankeyDiagram
    @State private var reloadKey = UUID()
    
    // Whether to show loading indicator
    // Hopefully API will let us manage state in the future.
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            if !networkMonitor.hasNetworkConnection {
                ContentUnavailableView(
                    "No Internet Connection",
                    systemImage: "wifi.exclamationmark",
                    description: Text("Please check your connection and try again.")
                )
            } else if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .onAppear {
                        // Simulate a delay to represent loading
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            isLoading = false
                        }
                    }
            } else {
                SankeyDiagram(
                    data,
                    nodeColors: colors,
                    nodeColorMode: .unique,
                    nodeWidth: 25,
                    nodePadding: 50,
                    nodeLabelColor: colorScheme == .light ? "black" : "white",
                    nodeLabelFontSize: 24,
                    nodeLabelBold: true,
                    nodeLabelPadding: 1,
                    linkColors: colors,
                    linkColorMode: .target,
                    layoutIterations: 1000
                )
                .id(reloadKey)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            reloadKey = UUID()
        }
        .toolbar {
            if networkMonitor.hasNetworkConnection {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        print("Finish me!")
                    } label: {
                        Label(String(), systemImage: "square.and.arrow.up")
                    }
                }
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

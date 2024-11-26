//
//  SankeyView.swift
//  Track
//
//  Created by Ethan Maxey on 11/25/24.
//

import SwiftUI

struct SankeyView: View {
    
    @State private var renderedImage = UIImage(systemName: "photo")
    @State private var reloadKey = UUID()
    @State private var orientation = UIDevice.current.orientation
    @State private var snapshotTrigger = false
    @State private var isShareEnabled = false
    
    var image: UIImage? {
        renderedImage?.resizableImage(
            withCapInsets: UIEdgeInsets(top: 150, left: 150, bottom: 150, right: 150),
            resizingMode: .tile
        )
    }

    
    var body: some View {
        SankeyMaticWebView(snapToggle: $snapshotTrigger, renderedImage: $renderedImage)
            .id(reloadKey)
            .edgesIgnoringSafeArea(.all)
            .toolbar {
                if isShareEnabled {
                    ShareLink(
                        item: Image(uiImage: image!),
                        preview: SharePreview(
                            "Check out my job search progress!",
                            image: Image(uiImage: image!)
                        )
                    )
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                if UIDevice.current.orientation.isPortrait {
                    if orientation != .portrait {
                        reloadKey = UUID()
                        orientation = .portrait
                        takeScreenShot()
                    }
                } else if UIDevice.current.orientation.isLandscape {
                    if orientation != .landscapeLeft || orientation == .landscapeRight {
                        reloadKey = UUID()
                        orientation = .landscapeLeft
                        takeScreenShot()
                    }
                }

            }
            .onAppear {
                takeScreenShot()
            }
    }
    
    private func takeScreenShot() {
        isShareEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            snapshotTrigger.toggle()
            isShareEnabled = true
        }
    }
}

#Preview("Light") {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(ViewModel.preview)
        .environment(NetworkMonitor())
}

#Preview("Dark") {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(ViewModel.preview)
        .environment(NetworkMonitor())
        .preferredColorScheme(.dark)
}

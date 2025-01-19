//
//  SankeyView.swift
//  Track
//
//  Created by Ethan Maxey on 11/25/24.
//

import SwiftUI
import TipKit

class SankeyViewModel: ObservableObject {
    @Published var image: UIImage?
}

struct SankeyView: View {
    @ObservedObject var sankeyViewModel = SankeyViewModel()
    @State private var snapshotTrigger = false
    @State private var orientation = UIDevice.current.orientation
    @State private var refreshOnAppearID = UUID()
    
    var image: UIImage? {
        sankeyViewModel.image?.resizableImage(
            withCapInsets: UIEdgeInsets(top: 150, left: 150, bottom: 150, right: 150),
            resizingMode: .tile
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // The main content
                VStack {
                    SankeyMaticWebView(
                        snapToggle: $snapshotTrigger,
                        orientation: $orientation,
                        sankeyViewModel: sankeyViewModel
                    )
                    .id(refreshOnAppearID)
                }
            }

            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                orientation = UIDevice.current.orientation
                takeScreenShot()
            }
            .onAppear {
                refreshOnAppearID = UUID()
                takeScreenShot()
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    refresh()
                }
            }
            .toolbar {
                if let image {
                    ShareLink(
                        item: Image(uiImage: image),
                        preview: SharePreview(
                            "Check out my job search progress!",
                            image: Image(uiImage: image)
                        )
                    )
                } else {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(.gray)
                }
            }
        }
    }
    
    private func takeScreenShot() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            snapshotTrigger.toggle()
        }
    }
    
    /// iPad view loads weird on initial load. Hopefullt this fixes it.
    private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            refreshOnAppearID = UUID()
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

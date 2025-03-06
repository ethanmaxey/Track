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
        sankeyViewModel.image
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
                reloadView()
                takeScreenShot(after: TimeInterval(2))
            }
            .onAppear {
                reloadView()
                takeScreenShot(after: TimeInterval(2))
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
                    .accessibilityIdentifier("share")
                } else {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundStyle(.gray)
                }
            }
        }
    }
    
    private func takeScreenShot(after seconds: TimeInterval = .zero) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            snapshotTrigger.toggle()
        }
    }
    
    /// iPad view loads weird on initial load. Hopefullt this fixes it.
    private func reloadView(after seconds: TimeInterval = .zero) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            orientation = UIDevice.current.orientation
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

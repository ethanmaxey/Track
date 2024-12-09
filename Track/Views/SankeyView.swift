//
//  SankeyView.swift
//  Track
//
//  Created by Ethan Maxey on 11/25/24.
//

import InterfaceOrientation
import SwiftUI
import TipKit

class SankeyViewModel: ObservableObject {
    @Published var image: UIImage?
}

struct SankeyView: View {
    @ObservedObject var viewModel = SankeyViewModel()
    @State private var snapshotTrigger = false
    
    var sankeyLandscapeTip = SankeyLandscapeTip()
    
    var image: UIImage? {
        viewModel.image?.resizableImage(
            withCapInsets: UIEdgeInsets(top: 150, left: 150, bottom: 150, right: 150),
            resizingMode: .tile
        )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // The main content
                VStack {
                    SankeyMaticWebView(snapToggle: $snapshotTrigger, viewModel: viewModel)
                }
                
                if UIDevice.current.orientation.isPortrait {
                    // The overlayed tip, moved up 1/4 of the page.
                    TipView(sankeyLandscapeTip, arrowEdge: .bottom)
                        .padding()
                        .offset(y: -UIScreen.main.bounds.height * 0.25)
                }
            }

            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                takeScreenShot()
            }
            .onAppear {
                takeScreenShot()
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

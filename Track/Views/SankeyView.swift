//
//  SankeyView.swift
//  Track
//
//  Created by Ethan Maxey on 11/25/24.
//

import InterfaceOrientation
import SwiftUI

class SankeyViewModel: ObservableObject {
    @Published var image: UIImage?
}

struct SankeyView: View {
    @State private var orientation = UIDevice.current.orientation
    @ObservedObject var viewModel = SankeyViewModel()
    @State private var snapshotTrigger = false
    
    var image: UIImage? {
        viewModel.image?.resizableImage(
            withCapInsets: UIEdgeInsets(top: 150, left: 150, bottom: 150, right: 150),
            resizingMode: .tile
        )
    }
    
    var body: some View {
        NavigationStack {
            SankeyMaticWebView(snapToggle: $snapshotTrigger, viewModel: viewModel)
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                    if UIDevice.current.orientation.isPortrait {
                        orientation = .portrait
                        takeScreenShot()
                    } else if UIDevice.current.orientation.isLandscape {
                        orientation = .landscapeLeft
                        takeScreenShot()
                    }
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

//
//  WillLoadHandler.swift
//  Track
//
//  Created by Ethan Maxey on 3/3/25.
//

import SwiftUI
import UIKit

private struct WillLoadHandler: UIViewControllerRepresentable {
    let onWillLoad: () -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        ViewWillDisappearViewController(onWillLoad: onWillLoad)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    private class ViewWillDisappearViewController: UIViewController {
        let onWillLoad: () -> Void

        init(onWillLoad: @escaping () -> Void) {
            self.onWillLoad = onWillLoad
            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            onWillLoad()
        }
    }
}

extension View {
    func viewDidLoad(_ perform: @escaping () -> Void) -> some View {
        background(WillLoadHandler(onWillLoad: perform))
    }
}

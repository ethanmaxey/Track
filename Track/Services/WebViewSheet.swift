//
//  WebViewSheet.swift
//  Track
//
//  Created by Ethan Maxey on 12/13/24.
//

import SwiftUI

struct WebViewSheet: View {
    let url: URL
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            WebView(url: url)
                .edgesIgnoringSafeArea(.all) // Extend into the safe area
                .navigationBarTitle(Text(""), displayMode: .inline)
                .navigationBarItems(trailing: Button("Close") {
                    isPresented = false
                })
        }
    }
}

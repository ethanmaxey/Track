//
//  WebView.swift
//  Track
//
//  Created by Ethan Maxey on 12/13/24.
//

import SwiftUI
import WebKit

// A SwiftUI wrapper for WKWebView
struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        let request = URLRequest(url: url)
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {}
}

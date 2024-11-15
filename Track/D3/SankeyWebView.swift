//
//  SankeyWebView.swift
//  Track
//
//  Created by Ethan Maxey on 11/11/24.
//

import SwiftUI
import WebKit

struct SankeyWebView: UIViewRepresentable {
    func updateUIView(_ webView: WKWebView, context: Context) {
        let htmlPath = Bundle.main.path(forResource: "indexOld", ofType: "html")
        let htmlUrl = URL(fileURLWithPath: htmlPath!, isDirectory: false)
        webView.loadFileURL(htmlUrl, allowingReadAccessTo: htmlUrl)
        webView.scrollView.isScrollEnabled = false
        
        // This prevents the webview from "flashing" randomly.
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.isInspectable = true
    }
}

class WebViewCoordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message)
    }
}

extension SankeyWebView {
    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.userContentController.add(context.coordinator, name: "notification")

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        return webView
    }
}

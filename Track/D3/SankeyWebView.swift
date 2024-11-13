//
//  SankeyWebView.swift
//  Track
//
//  Created by Ethan Maxey on 11/11/24.
//

import SwiftUI
import WebKit

struct SankeyWebView: UIViewRepresentable {
    let htmlName: String

    func updateUIView(_ webView: WKWebView, context: Context) {
        
        // Assuming 'index.html' and 'data_sankey.json' are in the same directory in your bundle
        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
            let dirUrl = url.deletingLastPathComponent()
            webView.loadFileURL(url, allowingReadAccessTo: dirUrl)
        }
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

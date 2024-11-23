//
//  SankeyMaticWebView.swift
//  Track
//
//  Created by Ethan Maxey on 11/14/24.
//

import SwiftUI
import WebKit

struct SankeyMaticWebView: UIViewRepresentable {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \JobListing.company, ascending: true)]) var jobs: FetchedResults<JobListing>
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let htmlPath = Bundle.main.path(forResource: "index", ofType: "html")
        let htmlUrl = URL(fileURLWithPath: htmlPath!, isDirectory: false)
        webView.loadFileURL(htmlUrl, allowingReadAccessTo: htmlUrl)
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        webView.isInspectable = true
        webView.isUserInteractionEnabled = false
    }
}

extension SankeyMaticWebView {
    func makeCoordinator() -> SankeyMaticWebViewCoordinator {
        SankeyMaticWebViewCoordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let input = getInput()
        
        let sankeyInputJS = """
        var originalLinesSourceHardCoded = `\(input)`;
        """
        
        let inputScript = WKUserScript(source: sankeyInputJS, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        
        let config = WKWebViewConfiguration()
        config.userContentController.addUserScript(inputScript)
        config.userContentController.add(context.coordinator, name: "jsErrorHandler")
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        
        return webView
    }
}

extension SankeyMaticWebView {
    func getInput() -> String {
        return """
        Applications [\(jobs.count { $0.interview })] Interviews
        Applications [\(jobs.count { $0.rejected })] Rejected
        Applications [\(jobs.count { $0.ghosted })] No Answer
        
        Interviews [\(jobs.count { $0.offer })] Offers
        Interviews [\(jobs.count { $0.no_offer })] No Offer
        
        Offers [\(jobs.count { $0.accepted })] Accepted
        Offers [\(jobs.count { $0.declined })] Declined
        """
    }
}

class SankeyMaticWebViewCoordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    
    // Handle JavaScript errors
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "jsErrorHandler", let errorInfo = message.body as? [String: Any] {
            print("JavaScript Error: \(errorInfo)")
        }
    }
    
    // Handle Swift navigation errors
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("WebView navigation error: \(error.localizedDescription)")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("WebView provisional navigation error: \(error.localizedDescription)")
    }
}


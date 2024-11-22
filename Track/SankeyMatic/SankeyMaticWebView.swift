//
//  SankeyMaticWebView.swift
//  Track
//
//  Created by Ethan Maxey on 11/14/24.
//

import SwiftUI
import WebKit

struct SankeyMaticWebView: UIViewRepresentable {
    var sankeyInput: String
    
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
        replaceScriptInFile()
        
        let config = WKWebViewConfiguration()
        
        // Enable JavaScript error logging
        config.userContentController.add(context.coordinator, name: "jsErrorHandler")
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        
        let sankeyInputJS = """
        originalLinesSourceHardCoded = `\(sankeyInput)`;
        """
        let updateScript = WKUserScript(source: sankeyInputJS, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        config.userContentController.addUserScript(updateScript)
        
        // Inject JavaScript to catch errors
        let errorLoggingScript = """
        window.onerror = function(message, source, lineno, colno, error) {
            window.webkit.messageHandlers.jsErrorHandler.postMessage(
                { message: message, source: source, lineno: lineno, colno: colno, error: error ? error.toString() : null }
            );
        };
        """
        let script = WKUserScript(source: errorLoggingScript, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        config.userContentController.addUserScript(script)
        
        return webView
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

// MARK: - Writing input to HTML
extension SankeyMaticWebView {
    func replaceScriptInFile() {
        do {
            // Read the content of the file
            let filePath = Bundle.main.path(forResource: "index", ofType: "html")
            let fileURL = URL(fileURLWithPath: filePath!)
            var htmlContent = try String(contentsOf: fileURL, encoding: .utf8)
            
            // Define the new script with normal string concatenation
            let newScript = "<script id=\"input\">\n" +
                            "    var originalLinesSourceHardCoded = '\\n" +
                            "      // Sample Job Search diagram:\\n\\n" +
                            "      Applications [4] Interviews\\n" +
                            "      Applications [369] Rejected\\n" +
                            "      Applications [4] No Answer\\n\\n" +
                            "      Interviews [2] Offers\\n" +
                            "      Interviews [2] No Offer\\n\\n" +
                            "      Offers [1] Accepted\\n" +
                            "      Offers [1] Declined\\n" +
                            "    '\n" +
                            "</script>"
            
            // Regex to find existing <script id="input">...</script>
            if let range = htmlContent.range(of: #"<script id="input">.*?</script>"#, options: .regularExpression) {
                htmlContent.replaceSubrange(range, with: newScript)
            } else {
                // If not found, append the new script
                htmlContent.append("\n\(newScript)")
            }
            
            // Write the modified content back to the file
            try htmlContent.write(to: fileURL, atomically: true, encoding: .utf8)
            print("Script replaced successfully.")
        } catch {
            print("An error occurred: \(error)")
        }
    }


}

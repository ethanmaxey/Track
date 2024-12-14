//
//  SankeyMaticWebView.swift
//  Track
//
//  Created by Ethan Maxey on 11/14/24.
//

import SwiftUI
import WebKit

struct SankeyMaticWebView: UIViewRepresentable {
    @Binding var snapToggle: Bool
    @Binding var orientation: UIDeviceOrientation
    
    @EnvironmentObject var viewModel: ViewModel
    
    let sankeyViewModel: SankeyViewModel
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let htmlPath = Bundle.main.path(forResource: "index", ofType: "html")
        let htmlUrl = URL(fileURLWithPath: htmlPath!, isDirectory: false)
        webView.loadFileURL(htmlUrl, allowingReadAccessTo: htmlUrl)
        webView.scrollView.isScrollEnabled = false
        webView.isInspectable = true
        webView.isUserInteractionEnabled = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        // Rotate 90 Degrees
        if orientation.isPortrait {
            let rotationAngle = CGFloat.pi / 2
            webView.transform = CGAffineTransform(rotationAngle: rotationAngle)
        } else {
            webView.transform = .identity
        }
        
        updateSankeyData(for: webView)
        
        guard snapToggle else {
            return
        }
        
        let _ = webView.takeSnapshot(with: nil) { img, err in
            if let img {
                sankeyViewModel.image = img
                snapToggle = false
            } else {
                print(err.debugDescription)
            }
        }
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
        
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        
        return webView
    }
}

// MARK: - Input Processing
extension SankeyMaticWebView {
    private func getInput() -> String {
        return """
        Applications [\(viewModel.jobs.count { $0.interview })] Interviews
        Applications [\(viewModel.jobs.count { $0.rejected })] Rejected
        Applications [\(viewModel.jobs.count { $0.ghosted })] No Answer
        
        Interviews [\(viewModel.jobs.count { $0.offer })] Offers
        Interviews [\(viewModel.jobs.count { $0.no_offer })] No Offer
        
        Offers [\(viewModel.jobs.count { $0.accepted })] Accepted
        Offers [\(viewModel.jobs.count { $0.declined })] Declined
        """
    }
    
    private func updateSankeyData(for webView: WKWebView) {
        let input = getInput()
        
        let sankeyInputJS = """
        originalLinesSourceHardCoded = `\(input)`;
        """
        
        webView.evaluateJavaScript(sankeyInputJS)
        
        processSankey(webView: webView)
    }
    
    private func processSankey(webView: WKWebView) {
        let jsFunction = "process_sankey();"
        webView.evaluateJavaScript(jsFunction)
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


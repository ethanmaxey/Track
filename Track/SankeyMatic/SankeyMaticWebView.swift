//
//  SankeyMaticWebView.swift
//  Track
//
//  Created by Ethan Maxey on 11/14/24.
//

import SwiftUI
import WebKit
import WidgetKit

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
        
        updateSankeyData(for: webView)
        
        guard snapToggle else {
            return
        }
        
        let _ = webView.takeSnapshot(with: nil) { img, err in
            if let img {
                if let imageData = img.pngData() {
                    sankeyViewModel.image = img
                    UserDefaults(suiteName: "group.shared.batch")?.set(imageData, forKey: "widgetImage")
                    snapToggle = false
                    WidgetCenter.shared.reloadAllTimelines()
                }
            } else {
                OSLogger.logger.error("Error Taking Snapshot")
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

        configureOrientation(for: webView)
        
        return webView
    }
    
    private func configureOrientation(for webView: WKWebView) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if diagramWillAppearUgly {
                let rotationAngle = CGFloat.pi / 2
                webView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            } else {
                webView.transform = .identity
            }
        } else {
            // If small, rotate. 440 is small enough.
            if UIScreen.main.bounds.width <= 440 {
                let rotationAngle = CGFloat.pi / 2
                webView.transform = CGAffineTransform(rotationAngle: rotationAngle)
            } else {
                webView.transform = .identity
            }
        }
    }
    
    /// Orientations in which the view is too narrow and diagram appears smashed together.
    private var diagramWillAppearUgly: Bool {
        UIDevice.current.orientation == .portrait ||
        UIDevice.current.orientation == .portraitUpsideDown ||
        UIDevice.current.orientation == .unknown
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
            OSLogger.logger.error("JavaScript Error: \(errorInfo)")
        }
    }
    
    // Handle Swift navigation errors
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        OSLogger.logger.error("WebView navigation error: \(error.localizedDescription)")
    }
    
    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        OSLogger.logger.error("WebView navigation error: \(error.localizedDescription)")
    }
}

// MARK: - Saving Image for Widgets
extension SankeyMaticWebView {
    func saveImageToDocuments(_ image: UIImage, fileName: String) -> URL? {
        guard let data = image.pngData() else {
            OSLogger.logger.error("Failed to convert image to PNG data.")
            return nil
        }
        
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let documentsURL = urls.first else {
            OSLogger.logger.error("Failed to retrieve documents directory.")
            return nil
        }
        
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        do {
            try data.write(to: fileURL)
            OSLogger.logger.error("Image saved to documents directory: \(fileURL.path)")
            return fileURL
        } catch {
            OSLogger.logger.error("Failed to save image: \(error.localizedDescription)")
            return nil
        }
    }

}

import CoreData
import SwiftUI
import WidgetKit

struct ImageProvider: TimelineProvider {
    func placeholder(in context: Context) -> ImageEntry {
        ImageEntry(date: Date(), image: UIImage(named: "Default")!)
    }

    func getSnapshot(in context: Context, completion: @escaping (ImageEntry) -> ()) {
        let entry = ImageEntry(date: Date(), image: UIImage(named: "Default")!)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ImageEntry>) -> ()) {
        var entries: [ImageEntry] = []
        let currentDate = Date()
        let entry = ImageEntry(date: currentDate, image: loadImage())

        entries.append(entry)

        // Refresh timeline every minute to reflect file changes
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate) ?? currentDate
        let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
        completion(timeline)
    }

    private func loadImage() -> UIImage {
        guard
            let widgetImage = UserDefaults(suiteName: "group.shared.batch")?.data(forKey: "widgetImage"),
            let widgetImage = UIImage(data: widgetImage)
        else {
            return UIImage(named: "Default")!
        }
        
        return widgetImage
    }
}

struct ImageEntry: TimelineEntry {
    let date: Date
    let image: UIImage
}

struct ImageWidgetEntryView: View {
    var entry: ImageEntry

    var body: some View {
        VStack {
            Image(uiImage: entry.image.trimming(top: 100, sides: 75)!)
                .resizable()
                .aspectRatio(contentMode: contentModeForImage)
        }
        .containerBackground(for: .widget) {
            determineBackgroundColor(for: entry.image)
        }
    }
    
    /// iPhone view is forced to load the WebView in a way that using `fill` works perfectly. iPad view can resize more so it is not as predicatable so using `fit` prevents overflow.
    private var contentModeForImage: ContentMode {
        UIDevice.current.userInterfaceIdiom == .phone ? .fill : .fit
    }

    private func determineBackgroundColor(for image: UIImage) -> Color {
        isImageBackgroundLight(image: image) ? .white : .black
    }

    private func isImageBackgroundLight(image: UIImage) -> Bool {
        guard let cgImage = image.cgImage else { return false }
        
        let inputImage = CIImage(cgImage: cgImage)
        let extent = inputImage.extent
        let context = CIContext(options: nil)
        
        // Get a small 1x1 pixel crop from the center of the image to analyze color
        let smallExtent = CGRect(x: extent.midX, y: extent.midY, width: 1, height: 1)
        guard let pixelImage = context.createCGImage(inputImage, from: smallExtent) else { return false }
        
        var bitmap = [UInt8](repeating: 0, count: 4) // RGBA
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let contextBitmap = CGContext(
            data: &bitmap,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )
        
        contextBitmap?.draw(pixelImage, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        
        // Analyze the average brightness (Y = 0.299R + 0.587G + 0.114B)
        let brightness = (0.299 * Double(bitmap[0]) + 0.587 * Double(bitmap[1]) + 0.114 * Double(bitmap[2])) / 255.0
        return brightness > 0.5
    }
}


@main
struct ImageWidget: Widget {
    let kind: String = "Sankey"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ImageProvider()) { entry in
            ImageWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Job Search")
        .description("This is a widget that displays your job search progress.")
        .supportedFamilies(ImageWidget.supportedWidgetFamilies)
    }
    
    /// Medium on iPhone and Extra Large on iPad for best experience.
    static fileprivate var supportedWidgetFamilies: [WidgetFamily] {
        UIDevice.current.userInterfaceIdiom == .phone ? [.systemMedium] : [.systemExtraLarge]
    }
}

extension UIImage {
    /// Trims the top and sides of the image by the specified amounts.
    /// - Parameters:
    ///   - top: The amount to trim from the top.
    ///   - sides: The amount to trim from each side.
    /// - Returns: A new `UIImage` instance with the specified amounts trimmed.
    fileprivate func trimming(top: CGFloat, sides: CGFloat) -> UIImage? {
        let size = self.size
        
        // Calculate the new size after trimming
        let newWidth = size.width - (2 * sides)
        let newHeight = size.height - top
        
        // Ensure the new size is valid
        guard newWidth > 0, newHeight > 0 else {
            return nil
        }
        
        // Define the cropping rectangle
        let cropRect = CGRect(
            x: sides, // Start from the left side, trimming `sides` amount
            y: top,   // Start from the top, trimming `top` amount
            width: newWidth,
            height: newHeight
        )
        
        // Perform the cropping
        guard let cgImage = self.cgImage,
              let croppedCGImage = cgImage.cropping(to: cropRect) else {
            return nil
        }
        
        // Create a new UIImage from the cropped CGImage
        return UIImage(cgImage: croppedCGImage, scale: self.scale, orientation: self.imageOrientation)
    }
}

#Preview(as: ImageWidget.supportedWidgetFamilies.first!) {
    ImageWidget()
} timeline: {
    ImageEntry(date: .now, image: UIImage(named: "Default")!)
}

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
            GeometryReader { proxy in
                Image(uiImage: entry.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
            }
        }
        .containerBackground(for: .widget) {
            determineBackgroundColor(for: entry.image)
        }
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

#Preview(as: ImageWidget.supportedWidgetFamilies.first!) {
    ImageWidget()
} timeline: {
    ImageEntry(date: .now, image: UIImage(named: "Default")!)
}

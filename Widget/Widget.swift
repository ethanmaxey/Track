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
        
        let targetSize = CGSize(width: 364, height: 169)
        
        guard
            let widgetImage = UserDefaults(suiteName: "group.shared.batch")?.data(forKey: "widgetImage"),
            let widgetImage = UIImage(data: widgetImage)?.scalePreservingAspectRatio(targetSize: targetSize)
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
            Image(uiImage: entry.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .containerBackground(for: .widget) {
                    Color.clear
                }
        }
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
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    ImageWidget()
} timeline: {
    ImageEntry(date: .now, image: UIImage(named: "Default")!)
}

extension UIImage {
    fileprivate func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
}

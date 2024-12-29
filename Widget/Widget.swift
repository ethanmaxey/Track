//
//  Widget.swift
//  Widget
//
//  Created by Ethan Maxey on 12/26/24.
//

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
        let entry = ImageEntry(date: Date(), image: UIImage(named: "Default")!)
        entries.append(entry)
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct ImageEntry: TimelineEntry {
    let date: Date
    let image: UIImage
}

struct ImageWidgetEntryView : View {

    var body: some View {
        VStack {
            Image(uiImage: UIImage(named: "Default")!)
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
    let kind: String = "ImageWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ImageProvider()) { entry in
            ImageWidgetEntryView()
        }
        .configurationDisplayName("My Image Widget")
        .description("This is a widget that displays a default image.")
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    ImageWidget()
} timeline: {
    ImageEntry(date: .now, image: UIImage(named: "Default")!)
}

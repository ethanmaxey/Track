//
//  VisualizeView.swift
//  Track
//
//  Created by Ethan Maxey on 9/3/24.
//

import Charts
import SwiftUI

struct VisualizeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: JobListing.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \JobListing.name, ascending: true)]
    ) private var jobs: FetchedResults<JobListing>

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Chart {
                ForEach(jobs, id: \.id) { job in
                    PointMark(
                        x: .value("Company", job.name ?? "Unknown"),
                        y: .value("Count", CGFloat(arc4random()) / CGFloat(UInt32.max))
                    )
                    .foregroundStyle(.blue)
                }
            }
            .chartForegroundStyleScale([
                "Unknown": .gray,
                "Default": .blue
            ])
            .frame(width: 300, height: 300) // Square dimensions
            .padding() // Add padding around the chart
            .background(.black)
            .environment(\.colorScheme, .dark) // Enforce dark mode
        }
    }
}


#Preview {
    VisualizeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

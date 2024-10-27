//
//  VisualizeView.swift
//  Track
//
//  Created by Ethan Maxey on 9/3/24.
//

import Sankey
import SwiftUI

struct VisualizeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: JobListing.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \JobListing.company, ascending: true)]
    ) private var jobs: FetchedResults<JobListing>

    var body: some View {
        VStack {
            SankeyDiagram(
                createSankeyData(),
                nodeWidth: 10,
                nodePadding: 10
            )
        }
        .preferredColorScheme(.dark)
    }
    
    func createSankeyData() -> [SankeyLink] {
        var links: [String: Int] = [:]

        for job in jobs {
            var path: [String] = ["\(job.company ?? "Unknown")"]

            if job.oa {
                path.append("OA")
            }
            if job.interview {
                path.append("Interview")
            }
            if job.offer {
                path.append("Offer")
            } else if job.rejected {
                path.append("Rejected")
            }

            for i in 0..<path.count-1 {
                let keyString = "\(path[i]) -> \(path[i + 1])"
                links[keyString, default: 0] += 1
            }
        }

        return links.map { SankeyLink(source: $0.key.components(separatedBy: " -> ").first!,
                                      target: $0.key.components(separatedBy: " -> ").last!,
                                      value: Double($0.value)) }
    }
}


#Preview {
    VisualizeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

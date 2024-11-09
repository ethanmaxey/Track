//
//  VisualizeView.swift
//  Track
//
//  Created by Ethan Maxey on 9/3/24.
//

import Sankey
import SwiftUI

struct VisualizeView: View {
    @Environment(\.colorScheme) var colorScheme
//    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(
//        entity: JobListing.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \JobListing.company, ascending: true)]
//    ) private var jobs: FetchedResults<JobListing>

    @State var data: [SankeyLink] = [
        ["Applications", "Interviews", "4"],
        ["Applications", "Rejected", "9"],
        ["Applications", "No Answer", "4"],
        ["Interviews", "Offers", "2"],
        ["Interviews", "No Offer", "2"],
        ["Offers", "Accepted", "1"],
        ["Offers", "Declined", "1"]
    ]
    
    let colors = [
        "#a6cee3", "#b2df8a", "#fb9a99", "#fdbf6f",
        "#cab2d6", "#ffff99", "#1f78b4", "#33a02c"
    ]
    
    var body: some View {
        VStack {
            SankeyDiagram(
                data,
                nodeColors: colors,
                nodeColorMode: .unique,
                nodeWidth: 25,
                nodePadding: 100,
                nodeLabelColor: "black",
                nodeLabelFontSize: 24,
                nodeLabelFontName: nil,
                nodeLabelBold: false,
                nodeLabelItalic: false,
                nodeLabelPadding: 1,
                nodeInteractivity: false,
                linkColors: colors,
                linkColorMode: .target,
                linkColorFill: nil,
                linkColorFillOpacity: nil,
                linkColorStroke: nil,
                linkColorStrokeWidth: 0,
                tooltipValueLabel: "",
                tooltipTextColor: "black",
                tooltipTextFontSize: 0,
                tooltipTextFontName: nil,
                tooltipTextBold: false,
                tooltipTextItalic: false,
                layoutIterations: 32
            )
        }
        .background(colorScheme == .dark ? Color.black : Color.white)
        .supportedInterfaceOrientations(.landscape)
    }
    
    /*
     Applications [4] Interviews
     Applications [9] Rejected
     Applications [4] No Answer

     Interviews [2] Offers
     Interviews [2] No Offer

     Offers [1] Accepted
     Offers [1] Declined
    */
    func createSankeyData() -> [SankeyLink] {
        var links: [String: Int] = [:]

//        for job in jobs {
//            var path: [String] = ["\(job.company ?? "Unknown")"]
//
//            if job.oa {
//                path.append("OA")
//            }
//            if job.interview {
//                path.append("Interview")
//            }
//            if job.offer {
//                path.append("Offer")
//            } else if job.rejected {
//                path.append("Rejected")
//            }
//
//            for i in 0..<path.count-1 {
//                let keyString = "\(path[i]) -> \(path[i + 1])"
//                links[keyString, default: 0] += 1
//            }
//        }

        return links.map { SankeyLink(source: $0.key.components(separatedBy: " -> ").first!,
                                      target: $0.key.components(separatedBy: " -> ").last!,
                                      value: Double($0.value)) }
    }
}

#Preview(traits: .landscapeLeft) {
    VisualizeView()
}

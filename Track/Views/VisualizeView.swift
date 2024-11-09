//
//  VisualizeView.swift
//  Track
//
//  Created by Ethan Maxey on 9/3/24.
//

import Sankey
import SwiftUI

struct VisualizeView: View {

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
                nodePadding: 50,
                nodeLabelColor: "black",
                nodeLabelFontSize: 24,
                nodeLabelPadding: 1,
                linkColors: colors,
                linkColorMode: .target,
                layoutIterations: 1000
            )
        }
        .supportedInterfaceOrientations(.landscape)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    print("Finish me!")
                } label: {
                    Label(String(), systemImage: "square.and.arrow.up")
                }
            }
        }
    }
}

#Preview("Light") {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(ViewModel.preview)
}

#Preview("Dark") {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(ViewModel.preview)
        .preferredColorScheme(.dark)
}

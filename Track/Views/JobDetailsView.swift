//
//  JobDetailsView.swift
//  Track
//
//  Created by Ethan Maxey on 9/1/24.
//

import SwiftUI

struct JobDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var job: JobListing
    
    var body: some View {
        VStack {
            Text(job.name ?? "No Name")
                .foregroundStyle(.blue)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

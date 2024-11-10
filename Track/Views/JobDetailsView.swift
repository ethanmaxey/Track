//
//  JobDetailsView.swift
//  Track
//
//  Created by Ethan Maxey on 9/1/24.
//

import SwiftUI

struct JobDetailsView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var job: JobListing

    var body: some View {
        VStack {
            Form {
                Text(job.company ?? "")

                Section(header: Text("Job Details")) {
                    Toggle("Online Assesment", isOn: $job.oa)
                        .onChange(of: job.oa) {
                            viewModel.saveContext()
                        }

                    Toggle("Interview Invite", isOn: $job.interview)
                        .onChange(of: job.interview) {
                            viewModel.saveContext()
                        }

                    Toggle("Received Offer", isOn: $job.offer)
                        .onChange(of: job.offer) {
                            viewModel.saveContext()
                        }

                    Toggle("Rejected", isOn: $job.rejected)
                        .onChange(of: job.rejected) {
                            viewModel.saveContext()
                        }
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

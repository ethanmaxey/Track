//
//  JobDetailsView.swift
//  Track
//
//  Created by Ethan Maxey on 9/1/24.
//

import SwiftUI

struct JobDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: ViewModel
    var job: JobListing
    
    // Temporary state for the toggles
    @State private var oa: Bool
    @State private var interview: Bool
    @State private var offer: Bool
    @State private var rejected: Bool

    // Initialize state from the job entity
    init(job: JobListing) {
        self.job = job
        _oa = State(initialValue: job.oa)
        _interview = State(initialValue: job.interview)
        _offer = State(initialValue: job.offer)
        _rejected = State(initialValue: job.rejected)
    }
    
    var body: some View {
        VStack {
            Form {
                Text(job.company ?? "")
                
                Section(header: Text("Job Details")) {
                    Toggle("Online Assesment", isOn: $oa)
                        .onChange(of: oa) {
                            viewModel.updateJobDetail(for: \.oa, value: oa, job: job)
                        }

                    Toggle("Interview Invite", isOn: $interview)
                        .onChange(of: interview) {
                            viewModel.updateJobDetail(for: \.interview, value: interview, job: job)
                        }

                    Toggle("Received Offer", isOn: $offer)
                        .onChange(of: offer) {
                            viewModel.updateJobDetail(for: \.offer, value: offer, job: job)
                        }

                    Toggle("Rejected", isOn: $rejected)  
                        .onChange(of: rejected) { 
                            viewModel.updateJobDetail(for: \.rejected, value: rejected, job: job)
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

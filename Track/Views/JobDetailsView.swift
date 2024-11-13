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
    
    @State var sectionOneExpanded: Bool = true
    @State var sectionTwoExpanded: Bool = false
    @State var sectionThreeExpanded: Bool = false
    
    // Start
    // -> Applications
    
    // First stage
    // -> Applications -> Interview
    // -> Applications -> Rejected
    // -> Applications -> Ghosted
    
    // Second Stage
    // -> Applications -> Interview -> Offers
    // -> Applications -> Interview -> No Offer
    
    // Third Stage
    // -> Applications -> Interview -> Offers -> Accepted
    // -> Applications -> Interview -> Offers -> Declined

    var body: some View {
        VStack {
            Form {
                Section("Phase I", isExpanded: $sectionOneExpanded) {
                    Toggle("Ghosted", isOn: $job.ghosted)
                        .onChange(of: job.ghosted) {
                            viewModel.saveContext()
                            updateExpansionStates()
                        }
                    
                    Toggle("Rejected", isOn: $job.rejected)
                        .onChange(of: job.rejected) {
                            viewModel.saveContext()
                            updateExpansionStates()
                        }

                    Toggle("Interview", isOn: $job.interview)
                        .onChange(of: job.interview) {
                            viewModel.saveContext()
                            updateExpansionStates()
                        }
                }
                
                Section("Phase II", isExpanded: $sectionTwoExpanded) {
                    Toggle("Offer", isOn: $job.offer)
                        .onChange(of: job.offer) {
                            viewModel.saveContext()
                            updateExpansionStates()
                        }
                    
                    Toggle("No Offer", isOn: $job.no_offer)
                        .onChange(of: job.no_offer) {
                            viewModel.saveContext()
                            updateExpansionStates()
                        }
                }
                
                Section("Phase III", isExpanded: $sectionThreeExpanded) {
                    Toggle("Accepted", isOn: $job.accepted)
                        .onChange(of: job.accepted) {
                            viewModel.saveContext()
                        }
                    
                    Toggle("Declined", isOn: $job.declined)
                        .onChange(of: job.declined) {
                            viewModel.saveContext()
                        }
                }
            }
            .animation(.easeInOut, value: sectionTwoExpanded)
            .animation(.easeInOut, value: sectionThreeExpanded)
        }
        .onAppear {
            updateExpansionStates()
        }
    }
    
    private func updateExpansionStates() {
        sectionTwoExpanded = job.interview || job.rejected || job.ghosted
        sectionThreeExpanded = job.offer || job.no_offer
    }
}

#Preview("Light") {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(ViewModel.preview)
        .environment(NetworkMonitor())
}

#Preview("Dark") {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(ViewModel.preview)
        .environment(NetworkMonitor())
        .preferredColorScheme(.dark)
}

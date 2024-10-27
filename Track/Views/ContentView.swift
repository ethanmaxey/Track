//
//  ContentView.swift
//  Track
//
//  Created by Ethan Maxey on 8/31/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: []) var jobs: FetchedResults<JobListing>
    @EnvironmentObject var viewModel: ViewModel

    @State private var isPresented = false
    @State private var addJobAlertData = String()
    @State private var searchText = String()
    @State private var isFiltersPresented = false
    @State private var filterCriteria: ApplicationStatus = .applied
    
    var results: [JobListing] {
        searchText.isEmpty ? Array(jobs) : jobs.filter { $0.company?.contains(searchText) ?? false }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(results, id: \.self)  { job in
                    NavigationLink(destination: JobDetailsView(job: job)) {
                        Text(job.company ?? "Uh Oh! No name found.")
                    }
                    .listRowBackground(Color.black)
                }
                .onDelete(perform: { offsets in
                    viewModel.deleteJobs(offsets: offsets, from: Array(jobs))
                })
            }
            .styleList()
            .searchable(text: $searchText)
            .foregroundStyle(.blue)
            .filterSheet(isPresented: $isFiltersPresented, filterCriteria: filterCriteria)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    RoundedButton(buttonType: .navigationLink(
                        destination: AnyView(VisualizeView())), text: "Visualize", color: .white
                    )
                    
                    RoundedButton(buttonType: .button(action: {
                        isPresented = true
                    }), text: "New Job", color: .blue)
                    .customAlert(
                        "Congrats! Where did you apply?",
                        isPresented: $isPresented,
                        presenting: addJobAlertData,
                        actionText: "Yes, Done"
                    ) { userInput in
                        viewModel.addJob(company: userInput)
                    } message: { value in
                        Text("Showing alert for \(value)… And adding a long text for preview.")
                    }
                }
            }
            .toolbarBackground(.black, for: .navigationBar)
            .toolbarBackground(.automatic, for: .bottomBar)
            .toolbarBackground(.black, for: .bottomBar)
            .toolbarBackground(.visible, for: .bottomBar)
            .preferredColorScheme(.dark)
        }
        .background(Color.black)
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).environmentObject(ViewModel.preview)
}

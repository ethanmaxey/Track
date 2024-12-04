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
    @FetchRequest(
        entity: JobListing.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \JobListing.company, ascending: true)],
        predicate: nil,
        animation: .default
    )
    var jobs: FetchedResults<JobListing>
    
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var refreshing = false
    private var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)

    @State var isAddJobAlertPresented = false
    @State private var addJobAlertData = String()
    @State private var searchText = String()
    @State private var isFiltersPresented = false
    @State private var filterCriteria: ApplicationStatus = .applied
    
    // To passed into SankeyMaticWebView as binding.
    @State private var sankeyOrigin: CGPoint = .zero
    @State private var sankeySize: CGSize = .zero
    
    var results: [JobListing] {
        searchText.isEmpty ? Array(jobs) : jobs.filter {
            $0.company?.contains(searchText) ?? false
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(results, id: \.self)  { job in
                    NavigationLink(destination: JobDetailsView(job: job)) {
                        Text((job.company ?? "Uh Oh! No name found." ) + (refreshing ? "" : ""))
                    }
                }
                .onDelete(perform: { offsets in
                    viewModel.deleteJobs(offsets: offsets, from: Array(jobs))
                })
                .onReceive(didSave) { _ in
                     refreshing.toggle()
                }
            }
            .styleList()
            .searchable(text: $searchText)
            .toolbar(content: contentViewToolbarContent)
        }
    }
}

// MARK: - Toolbar
extension ContentView {
    @ToolbarContentBuilder
    public func contentViewToolbarContent() -> some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            HStack {
                
                Spacer()
                
                RoundedButton(
                    buttonType: .navigationLink(destination: AnyView(SankeyView())),
                    text: "Visualize",
                    theme: .white
                )
                
                Spacer()
                
                RoundedButton(buttonType: .button(action: {
                    isAddJobAlertPresented = true
                }), text: "Add Job", theme: .blue)
                .customAlert(
                    "Congrats! Where did you apply?",
                    isPresented: $isAddJobAlertPresented,
                    presenting: addJobAlertData,
                    actionText: "Yes, Done"
                ) { userInput in
                    viewModel.addJob(company: userInput)
                } message: { value in
                    Text("Showing alert for \(value)… And adding a long text for preview.")
                }
                
                Spacer()
            }
        }
        
        ToolbarItem(placement: .principal) {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .padding(5)
        }
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

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
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \JobListing.company, ascending: true)]) var jobs: FetchedResults<JobListing>
    @EnvironmentObject var viewModel: ViewModel

    @State var isPresented = false
    @State var isLandscapePresented = false
    @State private var addJobAlertData = String()
    @State private var searchText = String()
    @State private var isFiltersPresented = false
    @State private var filterCriteria: ApplicationStatus = .applied
    
    // Changing this will force an update on SankeyWebView
    @State private var reloadKey = UUID()
    @State private var orientation = UIDevice.current.orientation
    
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
                }
                .onDelete(perform: { offsets in
                    viewModel.deleteJobs(offsets: offsets, from: Array(jobs))
                })
            }
            .styleList()
            .searchable(text: $searchText) 
            .filterSheet(isPresented: $isFiltersPresented, filterCriteria: filterCriteria)
            .toolbar(content: contentViewToolbarContent)
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                if UIDevice.current.orientation != orientation {
                    reloadKey = UUID()
                    orientation = UIDevice.current.orientation
                }
            }
        }
    }
}

// MARK: - Toolbar
extension ContentView {
    @ToolbarContentBuilder
    public func contentViewToolbarContent() -> some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            HStack {
                RoundedButton(
                    buttonType: .navigationLink(
                        destination: AnyView(
                            VisualizeView(data: [
                                ["Applications", "Interviews", "\(jobs.count { $0.interview })"],
                                ["Applications", "Rejected", "\(jobs.count { $0.rejected })"],
                                ["Applications", "No Answer", "\(jobs.count { $0.ghosted })"],
                                ["Interviews", "Offers", "\(jobs.count { $0.offer })"],
                                ["Interviews", "No Offer", "\(jobs.count { $0.no_offer })"],
                                ["Offers", "Accepted", "\(jobs.count { $0.accepted })"],
                                ["Offers", "Declined", "\(jobs.count { $0.declined })"]
                            ])
                        )
                    ),
                    text: "Visualize",
                    theme: .white
                )
                
                RoundedButton(
                    buttonType: .navigationLink(
                        destination: AnyView(
                            SankeyMaticWebView()
                                    .id(reloadKey)
                                    .edgesIgnoringSafeArea(.all)
                        )
                    ),
                    text: "Matic",
                    theme: .white
                )
                
                RoundedButton(buttonType: .button(action: {
                    isPresented = true
                }), text: "New Job", theme: .blue)
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

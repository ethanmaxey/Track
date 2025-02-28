//
//  ContentView.swift
//  Track
//
//  Created by Ethan Maxey on 8/31/24.
//

import SwiftRater
import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(
        entity: JobListing.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \JobListing.date, ascending: false)],
        predicate: nil,
        animation: .default
    )
    var jobs: FetchedResults<JobListing>
    
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var refreshing = false
    private var didSave = NotificationCenter.default.publisher(for: .NSManagedObjectContextDidSave)

    @State var isAddJobAlertPresented = false
    @State private var addJobAlertData = String()
    @State private var isFilterSheetPresented: Bool = false
    
    @State private var searchText = String()
    @State private var isFiltersPresented = false
    
    // To passed into SankeyMaticWebView as binding.
    @State private var sankeyOrigin: CGPoint = .zero
    @State private var sankeySize: CGSize = .zero
    
    @AppStorage("filterState") private var storedFilterData: Data?
    @State private var filterState: FilterState = FilterState()

    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    var results: [JobListing] {
        jobs.filter { job in
            let matchesSearchText = searchText.isEmpty ||
                        (job.company?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                        (job.title?.localizedCaseInsensitiveContains(searchText) ?? false)
            
            let matchesStatuses = filterState.selectedStatuses.isEmpty || filterState.selectedStatuses.contains { status in
                switch status {
                case .declined:
                    return job.declined
                case .ghosted:
                    return job.ghosted
                case .inteviewed:
                    return job.interview
                case .no_offer:
                    return job.no_offer
                case .oa:
                    return job.oa
                case .offer:
                    return job.offer
                case .rejected:
                    return job.rejected
                }
            }
            let matchesDate: Bool
            if
                let filterDate = filterState.selectedDate,
                let operatorType = filterState.dateFilterOperator,
                let jobDate = job.date
            {
                switch operatorType {
                case .any:
                    matchesDate = true
                case .lessThan:
                    matchesDate = jobDate < filterDate
                case .greaterThan:
                    matchesDate = jobDate > filterDate
                case .equals:
                    matchesDate = Calendar.current.isDate(jobDate, inSameDayAs: filterDate)
                }
            } else {
                matchesDate = true // No date filter
            }

            return matchesSearchText && matchesStatuses && matchesDate
        }
        .sorted(by: { first, second in
            switch filterState.sortOption {
            case .dateAdded:
                let firstDate = first.date ?? Date.distantPast
                let secondDate = second.date ?? Date.distantPast
                return filterState.isAscending ? firstDate < secondDate : firstDate > secondDate
            case .alphabetical:
                let firstCompany = viewModel.sanitizedString(first.company ?? "")
                let secondCompany = viewModel.sanitizedString(second.company ?? "")
                return filterState.isAscending
                    ? firstCompany.localizedCaseInsensitiveCompare(secondCompany) == .orderedAscending
                    : firstCompany.localizedCaseInsensitiveCompare(secondCompany) == .orderedDescending
            }
        })
    }

    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            GeometryReader { geometry in
                NavigationSplitView(columnVisibility: $columnVisibility) {
                    List {
                        ForEach(results, id: \.self)  { job in
                            NavigationLink(
                                destination: JobDetailsView(job: job).id(job.id)
                            ) {
                                Text((job.company ?? "Uh Oh! No name found." ) + (refreshing ? "" : ""))
                            }
                        }
                        .onDelete { offsets in
                            viewModel.deleteJobs(offsets: offsets, from: results)
                        }
                        .onAppear {
                            SwiftRater.check()
                            
                            if let data = storedFilterData,
                               let savedState = try? JSONDecoder().decode(FilterState.self, from: data) {
                                filterState = savedState
                            }
                        }
                        .onReceive(didSave) { _ in
                            refreshing.toggle()
                        }
                        .onDisappear {
                            viewModel.saveContext()
                        }
                    }
                    .styleList()
                    .searchable(text: $searchText)
                    .toolbar(content: contentViewToolbarContent)
                    .sheet(isPresented: $isFilterSheetPresented) {
                        FilterSheet(
                            isPresented: $isFilterSheetPresented,
                            filterState: $filterState
                        )
                    }
                    .navigationSplitViewColumnWidth(
                        min: 250,
                        ideal: 275,
                        max: 300
                    )
                } content: {
                    ContentUnavailableView {
                        Label {
                            Text("Select a job from the sidebar to view details.")
                        } icon: {
                            Image("Logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        }
                    }
                    .navigationSplitViewColumnWidth(
                        min: geometry.size.width / 4,
                        ideal: geometry.size.width / 3,
                        max: geometry.size.width / 2
                    )
                } detail: {
                    SankeyView()
                        .navigationSplitViewColumnWidth(
                            min: geometry.size.width / 4,
                            ideal: geometry.size.width / 3,
                            max: geometry.size.width / 2
                        )
                }
                .navigationSplitViewStyle(.balanced)
            }
        } else {
            NavigationStack {
                List {
                    ForEach(results, id: \.self)  { job in
                        NavigationLink(destination: JobDetailsView(job: job)) {
                            Text((job.company ?? "Uh Oh! No name found." ) + (refreshing ? "" : ""))
                        }
                    }
                    .onDelete { offsets in
                        viewModel.deleteJobs(offsets: offsets, from: results)
                    }
                    .onAppear {
                        SwiftRater.check()
                        
                        if let data = storedFilterData,
                           let savedState = try? JSONDecoder().decode(FilterState.self, from: data) {
                            filterState = savedState
                        }
                    }
                    .onReceive(didSave) { _ in
                        refreshing.toggle()
                    }
                    .onDisappear {
                        viewModel.saveContext()
                    }
                }
                .styleList()
                .searchable(text: $searchText)
                .toolbar(content: contentViewToolbarContent)
            }
            .sheet(isPresented: $isFilterSheetPresented) {
                FilterSheet(
                    isPresented: $isFilterSheetPresented,
                    filterState: $filterState
                )
            }
        }
    }
}

// MARK: - Toolbar
extension HomeView {
    @ToolbarContentBuilder
    public func contentViewToolbarContent() -> some ToolbarContent {
        ToolbarItemGroup(placement: .principal) {
            HomeViewToolbarView(
                isAddJobAlertPresented: $isAddJobAlertPresented,
                addJobAlertData: $addJobAlertData,
                isFilterSheetPresented: $isFilterSheetPresented
            )
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

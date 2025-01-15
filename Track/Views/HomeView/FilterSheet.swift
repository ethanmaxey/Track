//
//  FilterSheet.swift
//  Track
//
//  Created by Ethan Maxey on 1/14/25.
//

import SwiftUI

struct FilterSheet: View {
    @Binding var isPresented: Bool
    @Binding var filterState: FilterState
    
    @AppStorage("filterState") private var storedFilterData: Data?
    
    let statuses: [JobStatus] = JobStatus.allCases
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Sort Options")) {
                        // Sort By Picker
                        HStack {
                            Picker("Sort By", selection: $filterState.sortOption) {
                                ForEach(SortOption.allCases, id: \.self) { option in
                                    Text(option.rawValue).tag(option)
                                }
                            }
                        }
                        
                        // Order Picker
                        Picker("Order", selection: $filterState.isAscending) {
                            Text("Ascending").tag(true)
                            Text("Descending").tag(false)
                        }
                    }

                    
                    Section(header: Text("Filter by Date")) {
                        DatePicker("Date", selection: Binding(
                            get: { filterState.selectedDate ?? Date() },
                            set: { filterState.selectedDate = $0 }
                        ), displayedComponents: .date)
                        
                        Picker("Criteria", selection: $filterState.dateFilterOperator) {
                            ForEach(DateFilterOperator.allCases, id: \.self) { op in
                                Text(op.rawValue).tag(op as DateFilterOperator?)
                            }
                        }
                    }

                    Section(header: Text("Filter by Status")) {
                        ForEach(JobStatus.allCases) { status in
                            Toggle(status.rawValue.capitalized, isOn: Binding(
                                get: { filterState.selectedStatuses.contains(status) },
                                set: { isSelected in
                                    if isSelected {
                                        filterState.selectedStatuses.append(status)
                                    } else {
                                        filterState.selectedStatuses.removeAll { $0 == status }
                                    }
                                }
                            ))
                        }
                    }
                }
            }
            .navigationBarTitle("Filters", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.blue)
            })
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    HStack {
                        Button("Clear Filters") {
                            filterState.selectedDate = nil
                            filterState.selectedStatuses = []
                            isPresented = false
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.red)
                        .padding()
                        
                        Spacer()
                        
                        Button("Apply Filters") {
                            isPresented = false
                        }
                        .buttonStyle(.bordered)
                        .padding()
                    }
                    .padding()
                }
            }
            .onChange(of: filterState) {
                if let encoded = try? JSONEncoder().encode(filterState) {
                    storedFilterData = encoded
                }
            }
        }
    }
}

#Preview("Light") {
    FilterSheet(
        isPresented: .constant(true),
        filterState: .constant(FilterState())
    )
    .environment(
        \.managedObjectContext,
         PersistenceController.preview.container.viewContext
    )
    .environmentObject(ViewModel.preview)
}

#Preview("Dark") {
    FilterSheet(
        isPresented: .constant(true),
        filterState: .constant(FilterState())
    )
    .environment(
        \.managedObjectContext,
         PersistenceController.preview.container.viewContext
    )
    .environmentObject(ViewModel.preview)
    .preferredColorScheme(.dark)
}

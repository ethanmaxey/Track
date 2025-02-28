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
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text(L10n.sortOptions)) {
                        // Sort By Picker
                        HStack {
                            Picker(L10n.sortBy, selection: $filterState.sortOption) {
                                ForEach(SortOption.allCases, id: \.self) { option in
                                    Text(option.text).tag(option)
                                }
                            }
                        }
                        
                        // Order Picker
                        Picker(L10n.order, selection: $filterState.isAscending) {
                            Text(L10n.ascending).tag(true)
                            Text(L10n.descending).tag(false)
                        }
                    }

                    
                    Section(header: Text(L10n.filterByDate)) {
                        DatePicker(L10n.date, selection: Binding(
                            get: { filterState.selectedDate ?? Date() },
                            set: { filterState.selectedDate = $0 }
                        ), displayedComponents: .date)
                        
                        Picker(L10n.criteria, selection: $filterState.dateFilterOperator) {
                            ForEach(DateFilterOperator.allCases, id: \.self) { op in
                                Text(op.text).tag(op as DateFilterOperator?)
                            }
                        }
                    }

                    Section(header: Text(L10n.filterByStatus)) {
                        ForEach(JobStatus.allCases) { status in
                            Toggle(status.text, isOn: Binding(
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
            .navigationBarTitle(L10n.filters, displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                isPresented = false
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.blue)
            })
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    HStack {
                        Button(L10n.clearFilters) {
                            filterState.selectedDate = nil
                            filterState.selectedStatuses = []
                            isPresented = false
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.red)
                        .padding()
                        
                        Spacer()
                        
                        Button(L10n.applyFilters) {
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

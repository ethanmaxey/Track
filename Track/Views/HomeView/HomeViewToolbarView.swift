//
//  HomeViewToolbarView.swift
//  Track
//
//  Created by Ethan Maxey on 12/8/24.
//

import SwiftUI

struct HomeViewToolbarView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @Binding var isAddJobAlertPresented: Bool
    @Binding var addJobAlertData: String
    @Binding var isFilterSheetPresented: Bool
    
    let width = UIScreen.main.bounds.width
    
    var body: some View {
            HStack {
                HStack {
                    if viewModel.shouldShowEditButton {
                        EditButton()
                    }
                    
                    // To equally match spacing, this represents the space of the filter button.
                    Spacer()
                }
                .frame(width: width * 0.4)
                    
                Spacer()
                
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .padding(5)
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Button(String(), systemImage: "line.3.horizontal.decrease") {
                        isFilterSheetPresented = true
                    }
                    .frame(minWidth: 30, maxWidth: 30)
                    
                    Button(String(), systemImage: "plus.circle") {
                        isAddJobAlertPresented = true
                    }
                    .accessibilityIdentifier("addJob")
                    .frame(minWidth: 30, maxWidth: 30)
                    .customAlert(
                        LocalizedStringKey(L10n.congrats),
                        isPresented: $isAddJobAlertPresented,
                        presenting: addJobAlertData,
                        actionText: LocalizedStringKey(L10n.yesDone)
                    ) { userInput in
                        viewModel.addJob(company: userInput)
                    } message: { value in
                        EmptyView()
                    }
                }
                .frame(width: width * 0.4)
            }
    }
}

#Preview("Light") {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(ViewModel.preview)
        .environment(\.locale, .init(identifier: "pt"))
}

#Preview("Dark") {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(ViewModel.preview)
        .preferredColorScheme(.dark)
}

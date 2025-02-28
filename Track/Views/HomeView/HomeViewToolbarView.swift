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
    
    var body: some View {
        HStack {
            if viewModel.shouldShowEditButton {
                EditButton().frame(minWidth: 30, maxWidth: 30)
            }
            
            // To equally match spacing, this represents the space of the filter button.
            Spacer().frame(minWidth: 30, maxWidth: 30)
            
            Spacer()
            
            Image("Logo")
                .resizable()
                .scaledToFit()
                .padding(5)
            
            Spacer()
            
            Button(String(), systemImage: "line.3.horizontal.decrease") {
                isFilterSheetPresented = true
            }
            .frame(minWidth: 30, maxWidth: 30)
            
            Button(String(), systemImage: "plus.circle") {
                isAddJobAlertPresented = true
            }
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
    }
}

#Preview("Light") {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(ViewModel.preview)
        .environment(\.locale, .init(identifier: "de"))
}

#Preview("Dark") {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(ViewModel.preview)
        .preferredColorScheme(.dark)
}

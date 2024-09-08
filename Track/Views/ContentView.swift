//
//  ContentView.swift
//  Track
//
//  Created by Ethan Maxey on 8/31/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var jobs: FetchedResults<JobListing>

    @State private var isPresented = false
    @State private var addJobAlertData: String = "Fake"
    
    var body: some View {
        NavigationView {
            List {
                ForEach(jobs) { job in
                    NavigationLink(destination: JobDetailsView(job: job)) {
                        Text(job.name ?? "No Name")
                    }
                    .listRowBackground(Color.black)
                }
                .onDelete(perform: deletejobs)
            }
            .styleList()
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    RoundedButton(buttonType: .navigationLink(
                        destination: AnyView(VisualizeView())), text: "Visualize", color: .white
                    )
                    
                    RoundedButton(buttonType: .button(action: {
                        isPresented = true
                    }), text: "New Job", color: .blue)
                    .customAlert(
                        "Alert Title",
                        isPresented: $isPresented,
                        presenting: addJobAlertData,
                        actionText: "Yes, Done"
                    ) { value in
                        addjob(name: value)
                    } message: { value in
                        Text("Showing alert for \(value)… And adding a long text for preview.")
                    }
                }
            }
            .toolbarBackground(.black, for: .bottomBar)
            .toolbarBackground(.visible, for: .bottomBar)
        }
        .background(Color.black)
    }

    private func addjob(name: String) {
        withAnimation {
            let newJob = JobListing(context: viewContext)
            newJob.id = UUID()
            newJob.name = name
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deletejobs(offsets: IndexSet) {
        withAnimation {
            offsets.map { jobs[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

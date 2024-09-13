//
//  ContentViewModel.swift
//  Track
//
//  Created by Ethan Maxey on 9/12/24.
//

import SwiftUI

extension ContentView {
    func addjob(name: String) {
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

    func deletejobs(offsets: IndexSet) {
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

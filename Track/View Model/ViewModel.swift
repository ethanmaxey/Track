//
//  ViewModel.swift
//  Track
//
//  Created by Ethan Maxey on 9/12/24.
//

import SwiftUI
import CoreData

class ViewModel: ObservableObject {
    private var viewContext: NSManagedObjectContext
    @FetchRequest(sortDescriptors: []) var jobs: FetchedResults<JobListing>

    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }

    func addJob(company: String) {
        withAnimation {
            let newJob = JobListing(context: viewContext)
            newJob.id = UUID()
            
            newJob.accepted = false
            newJob.company = company
            newJob.declined = false
            newJob.ghosted = true
            newJob.interview = false
            newJob.no_offer = false
            newJob.oa = false
            newJob.offer = false
            newJob.rejected = false

            do {
                try viewContext.save()
            } catch {
                // Handle the error appropriately
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    func deleteJobs(offsets: IndexSet, from jobList: [JobListing]) {
        withAnimation {
            offsets.map { jobList[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // handle the error
                print("Error saving context: \(error.localizedDescription)")
            }
        }
    }
    
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            fatalError()
        }
    }

}

// MARK: - Previews
extension ViewModel {
    static var preview: ViewModel {
        let controller = PersistenceController.preview // Assume this provides an in-memory context
        return ViewModel(context: controller.container.viewContext)
    }
}

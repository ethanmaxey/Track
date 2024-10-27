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
            newJob.company = company
            newJob.interview = false
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
    
    func updateJobDetail<T>(for keyPath: ReferenceWritableKeyPath<JobListing, T>, value: T, job: JobListing) {
        viewContext.performAndWait {
            job[keyPath: keyPath] = value
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                print("Error updating job: \(nsError), \(nsError.userInfo)")
            }
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

//
//  ViewModel.swift
//  Track
//
//  Created by Ethan Maxey on 9/12/24.
//

import CoreData
import SwiftUI
import TextToEmoji

class ViewModel: ObservableObject {
    @Published var jobs: [JobListing] = []
    @Published var refreshToggle: Bool = false
    
    private var viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchJobs()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchJobs),
            name: .NSManagedObjectContextDidSave,
            object: viewContext
        )
    }

    @objc func fetchJobs() {
        let request: NSFetchRequest<JobListing> = JobListing.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \JobListing.company, ascending: true)]
        if let results = try? viewContext.fetch(request) {
            DispatchQueue.main.async {
                self.jobs = results
            }
        }
    }
       
   func refresh() {
       refreshToggle.toggle()
   }

    func addJob(company: String) {
        withAnimation {
            let newJob = JobListing(context: viewContext)
            newJob.id = UUID()
            newJob.accepted = false
            newJob.declined = false
            newJob.ghosted = true
            newJob.interview = false
            newJob.no_offer = false
            newJob.oa = false
            newJob.offer = false
            newJob.rejected = false

            let useEmojis = UserDefaults.standard.bool(forKey: "useEmojis")
            if useEmojis {
                Task {
                    let emoji = try? await TextToEmoji.emoji(for: company)
                    guard let emoji else {
                        let randomEmoji = String(UnicodeScalar(Array(0x1F300...0x1F3F0).randomElement()!)!)
                        newJob.company = randomEmoji + company
                        return
                    }
                    
                    DispatchQueue.main.async { [weak self] in
                        withAnimation {
                            newJob.company = emoji + company
                            
                            do {
                                try self?.viewContext.save()
                                self?.fetchJobs()
                            } catch {
                                let nsError = error as NSError
                                print("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                        }
                    }
                }
            } else {
                newJob.company = company
            }
        }
    }


    func deleteJobs(offsets: IndexSet, from jobList: [JobListing]) {
        withAnimation {
            offsets.map { jobList[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
                fetchJobs()
            } catch {
                // handle the error
                print("Error saving context: \(error.localizedDescription)")
            }
        }
    }
    
    func saveContext() {
        do {
            try viewContext.save()
            fetchJobs()
        } catch {
            fatalError()
        }
    }

}

// MARK: - Previews
extension ViewModel {
    static var preview: ViewModel {
        let controller = PersistenceController.preview // Assume this provides an in-memory context
        return ViewModel(viewContext: controller.container.viewContext)
    }
}

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
    @Published var resumes: [Resume] = []
    @Published var refreshToggle: Bool = false
    
    private var viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        fetchJobs()
        fetchResumes()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchJobs),
            name: .NSManagedObjectContextDidSave,
            object: viewContext
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchResumes),
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
    
    @objc func fetchResumes() {
        let request: NSFetchRequest<Resume> = Resume.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Resume.fileName, ascending: true)]
        if let results = try? viewContext.fetch(request) {
            DispatchQueue.main.async {
                self.resumes = results
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
            newJob.date = Date.distantPast
            newJob.resume = nil

            let useEmojis = UserDefaults.standard.bool(forKey: "useEmojis")
            if useEmojis {
                Task {
                    let emoji = try? await TextToEmoji.emoji(for: company)
                    guard let emoji else {
                        let randomEmoji = String(UnicodeScalar(Array(0x1F300...0x1F3F0).randomElement()!)!)
                        newJob.company = randomEmoji + " " + company
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
                                OSLogger.logger.error("Unresolved error \(nsError), \(nsError.userInfo)")
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
                OSLogger.logger.error("Error saving context: \(error.localizedDescription)")
            }
        }
    }
    
    func saveContext() {
        do {
            try viewContext.save()
            fetchJobs()
            fetchResumes()
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

// MARK: - Resumes
extension ViewModel {
    func addResume(basedOn result: Result<[URL], Error>) -> Resume? {
        switch result {
        case .success(let data):
            let newResume = Resume(context: viewContext)
            
            if let fileURL = data.first {
                let fileName = fileURL.lastPathComponent
                newResume.fileName = fileName
                newResume.uploadDate = Date()
                
                let fileManager = FileManager.default
                let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                let destinationURL = directory.appendingPathComponent(fileName)
                
                do {
                    // Ensure directory exists
                    if !fileManager.fileExists(atPath: directory.path) {
                        try fileManager.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
                    }
                    
                    // Copy file to destination
                    try fileManager.copyItem(at: fileURL, to: destinationURL)
                    newResume.fileURL = destinationURL.absoluteString
                    OSLogger.logger.error("File successfully saved at: \(destinationURL.path)")
                } catch {
                    OSLogger.logger.error("Failed to copy file: \(error)")
                    return nil
                }
            }
            
            resumes.append(newResume)
            saveContext()
            return newResume
            
        case .failure(let error):
            OSLogger.logger.error("Add Resume did fail: \(error)")
            return nil
        }
    }
}

// MARK: - Filter Assist
extension ViewModel {
    func sanitizedString(_ string: String) -> String {
        // Use a regular expression to remove leading emojis
        let regex = try? NSRegularExpression(pattern: "^[\\p{Emoji}\\p{So}\\p{Sk}\\p{Sc}\\p{Sm}]+")
        let range = NSRange(location: 0, length: string.utf16.count)
        return regex?.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "") ?? string
    }

}

//
//  Persistence.swift
//  Track
//
//  Created by Ethan Maxey on 8/31/24.
//

import CoreData

class PersistenceController {
    static let shared = PersistenceController()

    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let facebook = JobListing(context: viewContext)
        facebook.company = "Facebook"
        facebook.id = UUID()
        facebook.ghosted = true
        facebook.title = L10n.softwareEngineer
        facebook.jobDescription = L10n.fingersCrossed
        
        let microsft = JobListing(context: viewContext)
        microsft.company = "Microsoft"
        microsft.id = UUID()
        microsft.ghosted = false
        microsft.rejected = true
        microsft.title = L10n.softwareEngineer
        microsft.jobDescription = L10n.fingersCrossed
        
        let apple = JobListing(context: viewContext)
        apple.company = "Apple"
        apple.id = UUID()
        apple.ghosted = false
        apple.interview = true
        apple.no_offer = true
        apple.title = L10n.softwareEngineer
        apple.jobDescription = L10n.fingersCrossed
        
        let google = JobListing(context: viewContext)
        google.company = "Google"
        google.id = UUID()
        google.ghosted = false
        google.interview = true
        google.offer = true
        google.accepted = true
        google.title = L10n.softwareEngineer
        google.jobDescription = L10n.fingersCrossed
        
        let amazon = JobListing(context: viewContext)
        amazon.company = "Amazon"
        amazon.id = UUID()
        amazon.ghosted = false
        amazon.interview = true
        amazon.offer = true
        amazon.declined = true
        amazon.title = L10n.softwareEngineer
        amazon.jobDescription = L10n.fingersCrossed
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Track")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        container.loadPersistentStores(completionHandler: { [weak self] (storeDescription, error) in
            if let error = error as NSError?, error.code == NSPersistentStoreIncompatibleVersionHashError {
                // Migration failed, delete the store
                if let storeURL = self?.container.persistentStoreDescriptions.first?.url {
                    do {
                        try FileManager.default.removeItem(at: storeURL)
                        try self?.container.persistentStoreCoordinator.addPersistentStore(
                            ofType: NSSQLiteStoreType,
                            configurationName: nil,
                            at: storeURL,
                            options: [
                                NSMigratePersistentStoresAutomaticallyOption: true,
                                NSInferMappingModelAutomaticallyOption: true
                            ]
                        )
                    } catch {
                        OSLogger.logger.error("Error recreating the persistent store: \(error)")
                    }
                }
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // Load default companies on first launch only
        if isFirstLaunch() {
            populateDefaultData()
        }
    }
    
    func addJob(
        company: String,
        interview: Bool = false,
        offer: Bool = false,
        no_offer: Bool = false,
        rejected: Bool = false,
        ghosted: Bool = true,
        accepted: Bool = false,
        declined: Bool = false
    ) {
        let newJob = JobListing(context: container.viewContext)
        newJob.id = UUID()
        newJob.company = company
        newJob.date = Date()
        
        newJob.interview = interview
        newJob.rejected = rejected
        newJob.ghosted = ghosted
    
        newJob.accepted = accepted
        newJob.declined = declined
        
        newJob.offer = offer
        newJob.no_offer = no_offer
        
        newJob.title = L10n.softwareEngineer
        newJob.jobDescription = L10n.fingersCrossed
        
        do {
            try container.viewContext.save()
        } catch {
            // Hmm.
        }
    }
    
    private func isFirstLaunch() -> Bool {
        let hasLaunched = UserDefaults.standard.bool(forKey: "hasLaunched")
        if !hasLaunched {
            UserDefaults.standard.set(true, forKey: "hasLaunched")
            UserDefaults.standard.synchronize()
            return true
        }
        return false
    }

    private func populateDefaultData() {
        // Save a preference
        UserDefaults.standard.set(true, forKey: "useEmojis")
        
        addJob(company: "🚗 Doordash", ghosted: true)
        addJob(company: "🏠 Airbnb", rejected: true, ghosted: false)
        addJob(company: "🍏 Apple", interview: true, no_offer: true, ghosted: false)
        addJob(company: "🔍 Google", interview: true, offer: true, ghosted: false, accepted: true)
        addJob(company: "🚀 NASA", interview: true, offer: true, ghosted: false, declined: true)
    }
}

//
//  JobDetailsView.swift
//  Track
//
//  Created by Ethan Maxey on 9/1/24.
//

import SwiftUI

struct JobDetailsView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var job: JobListing
    
    @State private var sectionOneExpanded: Bool = true
    @State private var sectionTwoExpanded: Bool = false
    @State private var sectionThreeExpanded: Bool = false
    
    @State private var isSyncing: Bool = false
    
    @State private var companyText: String
    @State private var jobDate: Date
    @State private var jobTitleText: String

    init(job: JobListing) {
        self.job = job
        // Initialize the state with the job's company or an empty string if nil
        _companyText = State(initialValue: job.company ?? "")
        _jobDate = State(initialValue: job.date ?? Date())
        _jobTitleText = State(initialValue: job.title ?? "")
    }
    
    var body: some View {
        VStack {
            Form {
                Section("Details") {
                    HStack {
                        Text("Company")
                        
                        Spacer()
                        
                        TextField("Company", text: $companyText)
                            .multilineTextAlignment(.trailing)
                            .onDisappear {
                                job.company = companyText
                                try? job.managedObjectContext?.save()
                                viewModel.saveContext()
                                NotificationCenter.default.post(name: .NSManagedObjectContextDidSave, object: job.managedObjectContext)
                                viewModel.objectWillChange.send()
                            }
                    }
                    
                    HStack {
                        Text("Title")
                        
                        Spacer()
                        
                        TextField("Job Title", text: $jobTitleText)
                            .multilineTextAlignment(.trailing)
                            .onDisappear {
                                job.title = jobTitleText
                                try? job.managedObjectContext?.save()
                                viewModel.saveContext()
                                NotificationCenter.default.post(name: .NSManagedObjectContextDidSave, object: job.managedObjectContext)
                                viewModel.objectWillChange.send()
                            }
                    }
                    
                    
                    DatePicker(
                        "Date",
                        selection: $jobDate,
                        displayedComponents: .date
                    )
                    .onDisappear {
                        job.date = jobDate
                        try? job.managedObjectContext?.save()
                        viewModel.saveContext()
                        NotificationCenter.default.post(name: .NSManagedObjectContextDidSave, object: job.managedObjectContext)
                        viewModel.objectWillChange.send()
                    }
                }
                
                /*
                Section("Resume") {
                    Button("Upload Resume") {
                        isDocumentPickerShowing.toggle()
                    }
                    .fileImporter(isPresented: $isDocumentPickerShowing, allowedContentTypes: [.pdf], allowsMultipleSelection: false) { result in
                        if let newResume = viewModel.addResume(basedOn: result), let url = newResume.fileURL {
                            job.resume = newResume
                            previewURL = URL(fileURLWithPath: url)
                        }
                    }

                    Picker("Selected Resume", selection: $job.resume) {
                        ForEach(viewModel.jobs.filter({ $0.resume != nil }).map({ $0.resume! }), id: \.self) { resume in
                            Text(resume.fileName ?? "Resume").tag(resume as Resume?)
                        }
                    }
                }
                 */

                Section("Phase I", isExpanded: $sectionOneExpanded) {
                    Toggle("Ghosted", isOn: $job.ghosted)
                        .onChange(of: job.ghosted) {
                            
                            
                            if job.ghosted {
                                job.rejected = false
                                job.interview = false
                                job.offer = false
                                job.no_offer = false
                                job.accepted = false
                                job.declined = false
                            }
                            
                            viewModel.saveContext()
                            updateExpansionStates()
                        }
                    
                    Toggle("Rejected", isOn: $job.rejected)
                        .onChange(of: job.rejected) {
                            viewModel.saveContext()
                            updateExpansionStates()
                        }

                    Toggle("Interview", isOn: $job.interview)
                        .onChange(of: job.interview) {
                            
                            if !job.interview {
                                job.offer = false
                                job.no_offer = false
                            }
                            
                            viewModel.saveContext()
                            updateExpansionStates()
                        }
                }
                
                Section("Phase II", isExpanded: $sectionTwoExpanded) {
                    Toggle("Offer", isOn: $job.offer)
                        .onChange(of: job.offer) {
                            if !isSyncing {
                                isSyncing = true
                                job.no_offer = !job.offer
                                viewModel.saveContext()
                                updateExpansionStates()
                                isSyncing = false
                            }
                        }
                    
                    Toggle("No Offer", isOn: $job.no_offer)
                        .onChange(of: job.no_offer) {
                            if !isSyncing {
                                isSyncing = true
                                job.offer = !job.no_offer
                                viewModel.saveContext()
                                updateExpansionStates()
                                isSyncing = false
                            }
                        }
                }
                
                Section("Phase III", isExpanded: $sectionThreeExpanded) {
                    Toggle("Accepted", isOn: $job.accepted)
                        .onChange(of: job.accepted) {
                            job.declined = !job.accepted
                            viewModel.saveContext()
                        }
                    
                    Toggle("Declined", isOn: $job.declined)
                        .onChange(of: job.declined) {
                            job.accepted = !job.declined
                            viewModel.saveContext()
                        }
                }
            }
            .animation(.easeInOut, value: sectionTwoExpanded)
            .animation(.easeInOut, value: sectionThreeExpanded)
        }
        .onAppear {
            updateExpansionStates()
        }
        
        /*
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if let selectedResume = job.resume, let url = selectedResume.fileURL {
                    Button {
                        if FileManager.default.fileExists(atPath: url) {
                            OSLogger.logger.error("File exists at path: \(url)")
                        } else {
                            OSLogger.logger.error("File does not exist at path: \(url)")
                        }

                        
                        previewURL = URL(filePath: url)
                    } label: {
                        Image(systemName: "doc.text.magnifyingglass")
                            .quickLookPreview($previewURL)
                    }
                }
            }
        }
         */
    }
    
    private func updateExpansionStates() {
        if job.ghosted || job.rejected {
            sectionTwoExpanded = false
        } else {
            sectionTwoExpanded = job.interview || job.rejected || job.ghosted
            sectionThreeExpanded = job.offer
        }
        
        if !job.ghosted && !job.rejected && !job.interview {
            sectionThreeExpanded = false
        }
    }
}

#Preview("Light") {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(ViewModel.preview)
}

#Preview("Dark") {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(ViewModel.preview)
        .preferredColorScheme(.dark)
}

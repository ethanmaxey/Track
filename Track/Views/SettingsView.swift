//
//  SettingsView.swift
//  Track
//
//  Created by Ethan Maxey on 12/8/24.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @AppStorage("useEmojis") private var useEmojis: Bool = true
    @AppStorage("jobTitles") private var jobTitlesData: Data = Data()
    
    @State private var jobTitles: [String] = []
    @State private var newJobTitle: String = ""
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Default Job Titles")) {
                    ForEach(jobTitles, id: \.self) { title in
                        Text(title)
                    }
                    .onDelete(perform: deleteJobTitle)
                    .onMove(perform: moveJobTitle)
                    
                    HStack {
                        TextField("Add Job Title", text: $newJobTitle)
                        Button("Add") {
                            guard !newJobTitle.isEmpty else { return }
                            jobTitles.append(newJobTitle)
                            newJobTitle = ""
                            saveJobTitles()
                        }
                    }
                }
                
                Section(header: Text(L10n.preferences)) {
                    Toggle(isOn: $useEmojis) {
                        Label(L10n.autoAddEmojiToJobs, systemImage: "face.smiling")
                    }
                }
                
                Section(header: Text(L10n.feedback)) {
                    Button {
                        AppStoreReview.requestReviewManually()
                    } label: {
                        Label(L10n.leaveAReview, systemImage: "pencil.and.scribble")
                    }
                }

                Section(header: Text(L10n.support)) {
                    Link(destination: URL(string: "https://ethanmaxey.netlify.app/track-privacy.html")!) {
                        Label(L10n.privacyPolicy, systemImage: "doc.text")
                    }
                    
                    Link(destination: URL(string: "https://ethanmaxey.netlify.app/track-support.html")!) {
                        Label(L10n.contactSupport, systemImage: "envelope")
                    }
                }

                if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    Section(header: Text(L10n.about)) {
                        HStack {
                            Text(L10n.appVersion)
                            Spacer()
                            Text(appVersion)
                        }
                    }
                }
            }
            .navigationTitle(L10n.settings)
            .listStyle(InsetGroupedListStyle())
            .toolbar { EditButton() }
        }
        .navigationViewStyle(.stack)
        .onAppear(perform: loadJobTitles)
    }
    
    private func saveJobTitles() {
        if let data = try? JSONEncoder().encode(jobTitles) {
            jobTitlesData = data
        }
    }
    
    private func loadJobTitles() {
        if let decoded = try? JSONDecoder().decode([String].self, from: jobTitlesData) {
            jobTitles = decoded
        }
    }
    
    private func deleteJobTitle(at offsets: IndexSet) {
        jobTitles.remove(atOffsets: offsets)
        saveJobTitles()
    }
    
    private func moveJobTitle(from source: IndexSet, to destination: Int) {
        jobTitles.move(fromOffsets: source, toOffset: destination)
        saveJobTitles()
    }
}

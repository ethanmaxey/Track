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

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Preferences")) {
                    Toggle(isOn: $useEmojis) {
                        Label("Auto-Add Emoji to Jobs", systemImage: "face.smiling")
                    }
                }
                
                Section(header: Text("Feedback")) {                    
                    Button {
                        AppStoreReview.requestReviewManually()
                    } label: {
                        Label("Leave a Review", systemImage: "pencil.and.scribble")
                    }

                }

                Section(header: Text("Support")) {
                    Link(destination: URL(string: "https://ethanmaxey.netlify.app/track-privacy.html")!) {
                        Label("Privacy Policy", systemImage: "doc.text")
                    }
                    
                    Link(destination: URL(string: "https://ethanmaxey.netlify.app/track-support.html")!) {
                        Label("Contact Support", systemImage: "envelope")
                    }
                }

                if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    Section(header: Text("About")) {
                        HStack {
                            Text("App Version")
                            Spacer()
                            Text(appVersion)
                            
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .listStyle(InsetGroupedListStyle())

        }
        .navigationViewStyle(.stack)
    }
}

#Preview("Light") {
    SettingsView()
}

#Preview("Dark") {
    SettingsView()
        .preferredColorScheme(.dark)
}

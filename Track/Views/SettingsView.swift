//
//  SettingsView.swift
//  Track
//
//  Created by Ethan Maxey on 12/8/24.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    @AppStorage("useEmojis") private var useEmojis: Bool = false // Default to `false` if no value exists in storage

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Preferences")) {
                    Toggle(isOn: $useEmojis) {
                        Label("Auto-Add Emoji to Jobs", systemImage: "face.smiling")
                    }
                }
                
                Section(header: Text("Feedback")) {
                    Button(action: {
                        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                    }) {
                        Label("Rate This App", systemImage: "star.fill")
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
    }
}

#Preview("Light") {
    SettingsView()
}

#Preview("Dark") {
    SettingsView()
        .preferredColorScheme(.dark)
}

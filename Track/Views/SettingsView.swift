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

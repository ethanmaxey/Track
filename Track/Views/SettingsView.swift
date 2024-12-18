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
    
    @State private var showPrivacyPolicy = false
    @State private var showContactSupport = false

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
                    Button {
                        showPrivacyPolicy = true
                    } label: {
                        Label("Privacy Policy", systemImage: "doc.text")
                    }

                    Button {
                        showContactSupport.toggle()
                    } label: {
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
            .sheet(isPresented: $showPrivacyPolicy) {
                if let url = URL(string: "https://ethanmaxey.netlify.app/track-privacy.html") {
                    ZStack(alignment: .topLeading) {
                        WebView(url: url)
                            .ignoresSafeArea()

                        Button {
                            showPrivacyPolicy.toggle()
                        } label: {
                            Image(systemName: "x.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding()
                        }
                    }
                }
            }
            .sheet(isPresented: $showContactSupport) {
                if let url = URL(string: "https://ethanmaxey.netlify.app/track-support.html") {
                    ZStack(alignment: .topLeading) {
                        WebView(url: url)
                            .ignoresSafeArea()

                        Button {
                            showContactSupport.toggle()
                        } label: {
                            Image(systemName: "x.circle")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .padding()
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

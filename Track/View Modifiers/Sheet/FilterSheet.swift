//
//  FilterSheet.swift
//  Track
//
//  Created by Ethan Maxey on 10/26/24.
//


import SwiftUI

struct FilterSheet: ViewModifier {
    @Binding var isPresented: Bool
    @State var filterCriteria: ApplicationStatus
    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                NavigationStack {
                    VStack {
                        Form {
                            Picker("Application Status", selection: $filterCriteria) {
                                ForEach(ApplicationStatus.allCases, id: \.self) {
                                    Text($0.rawValue.localizedUppercase)
                                }
                            }
                            .pickerStyle(.inline)
                        }
                        
                        HStack {
                            Spacer()
                            RoundedButton(buttonType: .button(action: {
                                isPresented.toggle()
                            }), text: "Apply", color: .blue)
                        }
                        .padding()
                    }
                    .navigationTitle("Filter")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarTitleTextColor(.blue)
                }
            }
    }
}

extension View {
    func filterSheet(isPresented: Binding<Bool>, filterCriteria: ApplicationStatus) -> some View {
        modifier(FilterSheet(isPresented: isPresented, filterCriteria: filterCriteria))
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).environmentObject(ViewModel.preview)
}

extension View {
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
}

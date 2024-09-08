//
//  Untitled.swift
//  Track
//
//  Created by Ethan Maxey on 9/1/24.
//

import SwiftUI

struct NavigationLinkStyle: ViewModifier {
    var listBackgroundColor: Color = .black
    var rowBackgroundColor: Color = .blue
    var textColor: Color = .white
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.blue)
            .background(listBackgroundColor)
            .scrollContentBackground(.hidden)
    }
}

extension View {
    func applyNavigationLinkColors() -> some View {
        modifier(NavigationLinkStyle())
    }
}

//#Preview {
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}

//
//  ListBackgroundColor.swift
//  Track
//
//  Created by Ethan Maxey on 8/31/24.
//

import SwiftUI

struct ListStyle: ViewModifier {
    var listBackgroundColor: Color = .black
    var rowBackgroundColor: Color = .blue
    var textColor: Color = .white
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.blue)
            .background(listBackgroundColor)
            .scrollContentBackground(.hidden)
            .listRowSeparator(.hidden)
    }
}

extension View {
    func styleList() -> some View {
        modifier(ListStyle())
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).environmentObject(ViewModel.preview)
}

//
//  RoundedButton.swift
//  Track
//
//  Created by Ethan Maxey on 9/1/24.
//

import SwiftUI

struct RoundedButton: View {
    @Environment(\.colorScheme) var colorScheme
    
    enum ButtonType {
        case navigationLink(destination: AnyView)
        case button(action: () -> Void)
    }
    
    let buttonType: ButtonType
    let text: String
    var theme: Color
    private let cornerRadius: CGFloat = 50
    
    var body: some View {
        switch buttonType {
        case .button(let action):
            Button(action: action) {
                content
            }
        case .navigationLink(let destination):
            NavigationLink(destination: destination) {
                content
            }
        }
    }
    
    private var content: some View {
        let isStandardTheme: Bool = theme == .black || theme == .white
        let textColor: Color = isStandardTheme ? (colorScheme == .dark ? .white : .black) : .white
        let backgroundColor: Color = isStandardTheme ? (colorScheme == .dark ? .black : .white) : theme

        return Text(text)
            .foregroundColor(textColor)
            .padding()
            .frame(minWidth: 100, maxWidth: 100)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(colorScheme == .dark ? .white : .black, lineWidth: 2)
            )
    }

}

#Preview("Light") {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).environmentObject(ViewModel.preview)
}

#Preview("Dark") {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext).environmentObject(ViewModel.preview)
        .preferredColorScheme(.dark)
}

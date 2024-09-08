//
//  RoundedButton.swift
//  Track
//
//  Created by Ethan Maxey on 9/1/24.
//

import SwiftUI

struct RoundedButton: View {
    
    enum ButtonType {
        case navigationLink(destination: AnyView)
        case button(action: () -> Void)
    }
    
    let buttonType: ButtonType
    let text: String
    var color: Color = .blue
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
        Text(text)
            .foregroundColor(color)
            .padding()
            .frame(minWidth: 100, maxWidth: 100)
            .background(Color.black)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: 2)
            )
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}

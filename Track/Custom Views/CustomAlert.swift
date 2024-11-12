//
//  CustomAlertView.swift
//  CustomAlert
//
//  Created by Marwa Abou Niaaj on 25/01/2024.
//

import SwiftUI

struct CustomAlertView<T: Hashable, M: View>: View {
    @Namespace private var namespace

    @Binding private var isPresented: Bool
    @State private var titleKey: LocalizedStringKey
    @State private var actionTextKey: LocalizedStringKey

    private var data: T?
    private var actionWithValue: ((String) -> ())?
    private var messageWithValue: ((T) -> M)?

    private var action: (() -> ())?
    private var message: (() -> M)?
    
    @State private var username: String = String()

    init(
        _ titleKey: LocalizedStringKey,
        _ isPresented: Binding<Bool>,
        presenting data: T?,
        actionTextKey: LocalizedStringKey,
        action: @escaping (String) -> (),
        @ViewBuilder message: @escaping (T) -> M
    ) {
        _titleKey = State(wrappedValue: titleKey)
        _actionTextKey = State(wrappedValue: actionTextKey)
        _isPresented = isPresented

        self.data = data
        self.action = nil
        self.message = nil
        self.actionWithValue = action
        self.messageWithValue = message
    }

    var body: some View {
        ZStack {
            Color.gray
                .ignoresSafeArea()
                .opacity(isPresented ? 0.6 : 0)
                .zIndex(1)
            
            VStack {
                VStack {
                    Text(titleKey)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.tint)
                        .padding(8)

                    // Cannot convert value of type 'some View' to expected argument type 'Text?'
                    TextField("", text: $username, prompt: DefaultText)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)

                    /// Buttons
                    HStack {
                        CancelButton
                        DoneButton
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.black)
                .cornerRadius(35)
            }
            .padding()
            .transition(.blurReplace)
            .frame(width: 400)
            .zIndex(2)
        }
        .ignoresSafeArea()
        .onAppear {
            show()
        }
    }

    // MARK: Buttons
    var CancelButton: some View {
        Button {
            Haptics.play(.light)
            dismiss()
        } label: {
            Text("Cancel")
                .font(.headline)
                .foregroundStyle(.tint)
                .padding()
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .background(Material.regular)
                .background(.gray)
                .clipShape(RoundedRectangle(cornerRadius: 30))
        }
    }

    var DoneButton: some View {
        Button {
            Haptics.play(.light)
            if !username.isEmpty {
                dismiss()
                actionWithValue?(username)
            } else {

            }

        } label: {
            Text(actionTextKey)
                .font(.headline).bold()
                .foregroundStyle(Color.white)
                .padding()
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .background(.tint)
                .clipShape(RoundedRectangle(cornerRadius: 30.0))
        }
    }
    
    var DefaultText: Text? {
        Text("Enter job name here.")
            .foregroundStyle(.gray)
    }

    func dismiss() {
        isPresented = false
    }

    func show() {
        isPresented = true
    }
}

// MARK: - Overload
extension CustomAlertView where T == Never {

    init(
        _ titleKey: LocalizedStringKey,
        _ isPresented: Binding<Bool>,
        actionTextKey: LocalizedStringKey,
        action: @escaping () -> (),
        @ViewBuilder message: @escaping () -> M
    ) where T == Never {
        _titleKey = State(wrappedValue: titleKey)
        _actionTextKey = State(wrappedValue: actionTextKey)
        _isPresented = isPresented

        self.data = nil
        self.action = action
        self.message = message
        self.actionWithValue = nil
        self.messageWithValue = nil
    }
}

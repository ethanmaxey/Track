//
//  OrientationView.swift
//  Track
//
//  Created by Ethan Maxey on 11/8/24.
//

import SwiftUI

extension View {
  @ViewBuilder func supportedInterfaceOrientations(
    _ orientations: UIInterfaceOrientationMask
  ) -> some View {
    modifier(SupportedInterfaceOrientationsModifier(orientations: orientations))
  }
}

private struct SupportedInterfaceOrientationsModifier: ViewModifier {
  let orientations: UIInterfaceOrientationMask

  @State private var previousOrientations = UIInterfaceOrientationMask.portrait

  func body(content: Content) -> some View {
    content
      .onAppear() {
        previousOrientations = AppDelegate.supportedInterfaceOrientations
        AppDelegate.supportedInterfaceOrientations = orientations
      }
      .onDisappear() {
        AppDelegate.supportedInterfaceOrientations = previousOrientations
      }
  }
}

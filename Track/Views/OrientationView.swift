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
      modifier(
        SupportedInterfaceOrientationsModifier(
            orientations: orientations
        )
      )
  }
}

private struct SupportedInterfaceOrientationsModifier: ViewModifier {
    let orientations: UIInterfaceOrientationMask
        
    func body(
        content: Content
    ) -> some View {
    content
      .onAppear() {
        AppDelegate.orientationLock = orientations
      }
      .onDisappear() {
          AppDelegate.orientationLock = .all
      }
  }
}

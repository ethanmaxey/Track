//
//  AppDelegate.swift
//  Track
//
//  Created by Ethan Maxey on 11/8/24.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    static var supportedInterfaceOrientations = UIInterfaceOrientationMask.portrait {
        didSet { updateSupportedInterfaceOrientationsInUI() }
      }
}

extension AppDelegate {
  private static func updateSupportedInterfaceOrientationsInUI() {
    if #available(iOS 16.0, *) {
      UIApplication.shared.connectedScenes.forEach { scene in
        if let windowScene = scene as? UIWindowScene {
          windowScene.requestGeometryUpdate(
            .iOS(interfaceOrientations: supportedInterfaceOrientations)
          )
        }
      }
      UIViewController.attemptRotationToDeviceOrientation()
    } else {
      if supportedInterfaceOrientations == .landscape {
        UIDevice.current.setValue(
          UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation"
        )
      } else {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
      }
    }
  }

  func application(
    _ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?
  ) -> UIInterfaceOrientationMask {
    Self.supportedInterfaceOrientations
  }
}

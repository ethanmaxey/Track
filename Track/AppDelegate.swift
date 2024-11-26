//
//  AppDelegate.swift
//  Track
//
//  Created by Ethan Maxey on 11/26/24.
//

import InterfaceOrientation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        InterfaceOrientationCoordinator.shared.supportedOrientations
    }
}

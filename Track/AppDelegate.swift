//
//  AppDelegate.swift
//  Track
//
//  Created by Ethan Maxey on 11/8/24.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    // MARK: - New
    static var orientationLock = UIInterfaceOrientationMask.portrait {
        didSet {
            UIApplication.shared.connectedScenes
                .forEach { scene in
                    if let windowScene = scene as? UIWindowScene {
                        windowScene
                            .requestGeometryUpdate(
                                .iOS(
                                    interfaceOrientations: orientationLock
                                )
                            )
                    }
                }
            UIApplication.shared
                .getWindow()?.rootViewController?
                .setNeedsUpdateOfSupportedInterfaceOrientations()
        }
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

extension UIApplication {
    func getWindow() -> UIWindow? {
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        guard let firstWindow = firstScene.windows.first else {
            return nil
        }
        return firstWindow
    }
}

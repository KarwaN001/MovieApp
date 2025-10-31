//
//  AppDelegate.swift
//  movieApp
//
//  Created by Karwan on 24/10/2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // No need to declare 'window' here since SceneDelegate handles it on iOS 13+

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // If you have global setups (Firebase, analytics, etc.), you’ll add them here later.
        print("✅ AppDelegate didFinishLaunchingWithOptions called")
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Make sure the configuration name matches your SceneDelegate setup
        let config = UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
        config.delegateClass = SceneDelegate.self
        return config
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        // Not used but must stay for compliance
    }
}

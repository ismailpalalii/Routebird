//
//  SceneDelegate.swift
//  Routebird
//
//  Created by İsmail Palalı on 12.06.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties

    var window: UIWindow?

    // MARK: - Scene Lifecycle

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }

        // MARK: - Window Setup

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MapViewController()
        self.window = window
        window.makeKeyAndVisible()
    }

    // MARK: - Optional Scene Lifecycle Methods

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

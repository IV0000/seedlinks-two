//
//  AppDelegate.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 02/04/23.
//
// swiftlint:disable line_length
import SwiftyBeaver
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupLogging()
        return true
    }

    func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    private func setupLogging() {
        let consoleDestination = ConsoleDestination()
        consoleDestination.levelColor.error = "❌ "
        consoleDestination.levelColor.warning = "⚠️ "
        consoleDestination.levelColor.debug = "👩🏻‍💻 "
        consoleDestination.levelColor.info = "ℹ️ "
        consoleDestination.levelColor.verbose = "🌱 "

        consoleDestination.format = "$DHH:mm:ss$d $C$L$c $N.$F:$l - $M"
        SwiftyBeaver.addDestination(consoleDestination)
    }
}

// swiftlint:enable line_length

//
//  AppDelegate.swift
//  IQKeyboardToolbarManager
//
//  Created by hackiftekhar on 07/23/2024.
//  Copyright (c) 2024 hackiftekhar. All rights reserved.
//

import UIKit
import IQKeyboardToolbarManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardToolbarManager.shared.isEnabled = true
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}
}

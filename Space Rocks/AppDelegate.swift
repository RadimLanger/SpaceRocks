//
//  AppDelegate.swift
//  Space Rocks
//
//  Created by Radim Langer on 02/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var appCoordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        self.appCoordinator = AppCoordinator(window: window)

        self.appCoordinator?.start()

        return true
    }
}


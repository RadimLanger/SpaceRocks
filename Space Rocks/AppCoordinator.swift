//
//  AppCoordinator.swift
//  Space Rocks
//
//  Created by Radim Langer on 04/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {

    let window = UIWindow()

    private var mapController = UIStoryboard.instantiateViewController(type: MapViewController.self)
    private var tableController = UIStoryboard.instantiateViewController(type: ResultsTableViewController.self)

    // Coordinator

    func start() {
        window.rootViewController = mapController
        window.makeKeyAndVisible()
    }

}

//
//  AppCoordinator.swift
//  Space Rocks
//
//  Created by Radim Langer on 04/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
    
    private let dependencyProvider: DependencyProvider = DependencyContainer()

    private(set) lazy var meteorsLoader = MeteorsLoader(coreDataController: dependencyProvider.coreDataController)

    private var mapController = UIStoryboard.instantiateViewController(type: MapViewController.self)
    private var tableController = UIStoryboard.instantiateViewController(type: ResultsTableViewController.self)
    private var detailController = UIStoryboard.instantiateViewController(type: DetailViewController.self)

    private func setupDataAndPresentControllers() {

        meteorsLoader.delegate = self

        mapController.delegate = self
        tableController.delegate = self
        detailController.delegate = self

        meteorsLoader.fetchDataFromAPI { [unowned self] meteorites in
            self.move(controller: self.tableController, toController: self.mapController)
            self.move(controller: self.detailController, toController: self.mapController)

            self.tableController.allMeteorites = meteorites
            self.mapController.meteorites = meteorites
        }
    }

    // Coordinator

    func start() {
        window.rootViewController = mapController
        window.makeKeyAndVisible()

        setupDataAndPresentControllers()
    }

    private func move(controller: UIViewController, toController: UIViewController) {
        toController.addChildViewController(controller)
        toController.view.addSubview(controller.view)
        controller.didMove(toParentViewController: toController)
    }
}

extension AppCoordinator: MeteorLoaderDelegate {
    func meteorLoaderCouldntLoadDataDueMissingInternetConnection(_ loader: MeteorsLoader) {
        mapController.present(AlertManager.noInternetConnectionAlert, animated: true, completion: nil)
    }
}

extension AppCoordinator: MapViewControllerDelegate {

    func mapViewControllerDidChangeRegion(_ controller: MapViewController, _ visibleMeteorites: [Meteorite]) {
        tableController.resetMeteoritesToAll()
        tableController.searchBar.endEditing(true)
    }

    func mapViewControllerDidSelectMeteorite(_ controller: MapViewController, _ meteorite: Meteorite) {
        tableController.animateSheetView(direction: .bottomHiddden)
        detailController.meteorite = meteorite
        detailController.animateSheetView(direction: .mid)
    }

    func mapViewControllerDidDeselectMeteorite(_ controller: MapViewController) {
        detailController.animateSheetView(direction: .bottomHiddden)
        tableController.animateSheetView(direction: .mid)
    }
}

extension AppCoordinator: ResultsTableViewControllerDelegate {
    func tableViewControllerDidSelectMeteorite(_ controller: ResultsTableViewController, _ meteorite: Meteorite) {

        mapController.selectAnnotation(meteorite: meteorite)

        detailController.meteorite = meteorite
        detailController.animateSheetView(direction: .mid)
    }
}

extension AppCoordinator: DetailViewControllerDelegate {
    func detailViewControllerDidTapDismissButton(_ controller: DetailViewController) {
        mapController.deselectSelectedAnnotation()
        tableController.animateSheetView(direction: .mid)
        tableController.resetMeteoritesToAll()
    }
}

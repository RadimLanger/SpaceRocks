//
//  CoreDataAccessing.swift
//  Space Rocks
//
//  Created by Radim Langer on 02/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import UIKit

protocol DependencyProvider: AnyObject {
    var coreDataController: CoreDataController { get }
}


final class DependencyContainer: DependencyProvider {

    var coreDataController: CoreDataController

    init() {
        self.coreDataController = CoreDataController()
    }
}



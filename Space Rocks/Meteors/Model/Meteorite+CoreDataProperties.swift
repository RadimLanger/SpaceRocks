//
//  Meteorite+CoreDataProperties.swift
//  Space Rocks
//
//  Created by Radim Langer on 10/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//
//

import Foundation
import CoreData


extension Meteorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meteorite> {
        return NSFetchRequest<Meteorite>(entityName: "Meteorite")
    }

    @NSManaged public var fallInfo: String?
    @NSManaged public var fallYearDate: Date?
    @NSManaged public var id: Int64
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var mass: String
    @NSManaged public var name: String
    @NSManaged public var recClass: String?

}

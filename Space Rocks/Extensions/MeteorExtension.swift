//
//  MeteorExtension.swift
//  Space Rocks
//
//  Created by Radim Langer on 02/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import CoreData
import MapKit

extension Meteorite: DateComponentsAccessing {

    convenience init?(
        context: NSManagedObjectContext,
        name: String,
        mass: String,
        year: String,
        recClass: String,
        id: Int64,
        fallInfo: String,
        longitude: Double,
        latitude: Double
    ) {
        
        self.init(context: context)

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")

        guard let impactDate = dateFormatter.date(from: year) else { return nil }

        self.name = name
        self.mass = mass
        self.fallYearDate = impactDate
        self.recClass = recClass
        self.id = id
        self.fallInfo = fallInfo
        self.longitude = longitude
        self.latitude = latitude
    }

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}


//
//  MeteorsLoader.swift
//  Space Rocks
//
//  Created by Radim Langer on 02/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import Alamofire
import SwiftyJSON
import CoreData

final class MeteorsLoader: CoreDataAccessing {

    var meteorites: Meteorites {

        let meteorites = coreDataController.retrieve(entityClass: Meteorites.self)

        guard meteorites.isEmpty == false else {
            return coreDataController.create(entityClass: Meteorites.self)
        }

        return meteorites.first!
    }

    func fetchDataFromAPI() {

        let APIURLString = "https://data.nasa.gov/resource/y77d-th95.json?$where=year >= '2011-01-01T00:00:00'"
        let header = ["X-App-Token": "glEDYc5VHKpULc6er0kZlvZIv"]

        guard let URL = APIURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        var newMeteorites = NSMutableSet() // TODO: generate it by yourself to use swift Set in CD

        Alamofire.request(URL, method: .get, parameters: nil, headers: header).responseJSON { response in

            guard let json = response.result.value else { return }

            let jsonObject = JSON(json)


            jsonObject.forEach { _, subJSON in // TODO: check if there
                let name = subJSON["name"].stringValue
                let mass = subJSON["mass"].stringValue
                let year = subJSON["year"].stringValue
                let recclass = subJSON["recclass"].stringValue
                let id = subJSON["id"].intValue
                let fall = subJSON["fall"].stringValue
                let longitude = subJSON["geolocation", "coordinates"][0].doubleValue
                let latitude  = subJSON["geolocation", "coordinates"][1].doubleValue

                if let meteorite = Meteorite(
                    context: self.coreDataController.managedContext,
                    name: name,
                    mass: mass,
                    year: year,
                    recClass: recclass,
                    id: Int64(id),
                    fallInfo: fall,
                    longitude: longitude,
                    latitude: latitude // TODO: some are missing longitude and latitude
                ) {
                    newMeteorites.add(meteorite)
                }
            }

            self.meteorites.lastUpdateDate = Date()
            self.meteorites.meteorites = newMeteorites.copy() as! NSSet

            self.coreDataController.save()
        }
    }
}

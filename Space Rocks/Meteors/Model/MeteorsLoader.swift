//
//  MeteorsLoader.swift
//  Space Rocks
//
//  Created by Radim Langer on 02/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol MeteorLoaderDelegate: AnyObject {
    func meteorLoaderCouldntLoadDataDueMissingInternetConnection(_ loader: MeteorsLoader)
}

final class MeteorsLoader: DateComponentsAccessing {

    weak var delegate: MeteorLoaderDelegate?

    private let networkReachabilityManager = Alamofire.NetworkReachabilityManager()

    private let coreDataController: CoreDataController

    private let storage = UserDefaults.standard

    init(coreDataController: CoreDataController) {
        self.coreDataController = coreDataController
    }

    private var meteorites: [Meteorite] {
        return coreDataController.retrieve(entityClass: Meteorite.self, sortBy: "mass", isAscending: false)
    }

    private var shouldFetchNewData: Bool {

        let interval = storage.double(forKey: "lastSuccessfullUpdateInterval")

        if meteorites.count == 0 || interval == 0.0 {
            return true
        }

        let lastUpdateDate = Date(timeIntervalSince1970: interval)
        return calendar.dateComponents([.day], from: lastUpdateDate, to: Date()).day! >= 1
    }

    private func listenForInternetChangeAndLoadIfAvailable(completion: @escaping ([Meteorite]) -> Void) {
        networkReachabilityManager?.listener = { [weak self] _ in
            if self?.networkReachabilityManager?.isReachable ?? false {
                self?.networkReachabilityManager?.stopListening()
                self?.fetchDataFromAPI(completion: completion)
            }
        }
    }

    func fetchDataFromAPI(completion: @escaping ([Meteorite]) -> Void) {

        guard shouldFetchNewData
        else {
            completion(meteorites)
            return
        }

        if networkReachabilityManager?.isReachable ?? false == false {
            listenForInternetChangeAndLoadIfAvailable(completion: completion)
            delegate?.meteorLoaderCouldntLoadDataDueMissingInternetConnection(self)
            return
        }

         // i know i could fetch entities by predicate and then update them, but it's for discussion...
        coreDataController.deleteAllEntities(entityClass: Meteorite.self)
        coreDataController.save()

        let APIURLString = "https://data.nasa.gov/resource/y77d-th95.json?$where=year >= '2011-01-01T00:00:00'"
        let header = ["X-App-Token": "glEDYc5VHKpULc6er0kZlvZIv"]

        guard let URL = APIURLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        var newMeteorites = [Meteorite]()

        Alamofire.request(URL, method: .get, parameters: nil, headers: header).responseJSON { response in

            guard let json = response.result.value else { return }

            let jsonObject = JSON(json)

            jsonObject.forEach { _, subJSON in 
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
                    latitude: latitude
                ) {
                    newMeteorites.append(meteorite)
                }
            }

            DispatchQueue.main.async {
                self.storage.set(Date().timeIntervalSince1970, forKey: "lastSuccessfullUpdateInterval")
                self.coreDataController.save()
                completion(newMeteorites.sorted(by: { Double($0.mass) ?? 0 > Double($1.mass) ?? 0}))
            }
        }
    }
}

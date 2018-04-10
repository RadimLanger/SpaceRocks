//
//  CLLocationCoordinate2D+Equatable.swift
//  Space Rocks
//
//  Created by Radim Langer on 07/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import MapKit

extension CLLocationCoordinate2D: Equatable { }

public func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
    let eps = 0.00001
    return (fabs(lhs.latitude - rhs.latitude) < eps) && (fabs(lhs.longitude - rhs.longitude) < eps)
}


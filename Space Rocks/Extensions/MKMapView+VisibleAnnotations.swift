//
//  MKMapView+VisibleAnnotations.swift
//  Space Rocks
//
//  Created by Radim Langer on 08/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import MapKit

extension MKMapView {
    var visibleAnnotations: [MKAnnotation] {
        return self.annotations(in: self.visibleMapRect).map { obj -> MKAnnotation in return obj as! MKAnnotation }
    }
}


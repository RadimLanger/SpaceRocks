//
//  Double+Round.swift
//  Space Rocks
//
//  Created by Radim Langer on 09/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import UIKit

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


//
//  SharedDateFormatter.swift
//  Space Rocks
//
//  Created by Radim Langer on 02/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import Foundation

protocol DateFormatterAccessing: AnyObject {

}

extension DateFormatterAccessing {
    var dateFormatter: DateFormatter {
         return SharedDateFormatter.dateFormatter
    }
}

final class SharedDateFormatter {
    static let dateFormatter = DateFormatter()
}

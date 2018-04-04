//
//  SharedDateFormatter.swift
//  Space Rocks
//
//  Created by Radim Langer on 02/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import Foundation

protocol DateComponentsAccessing: AnyObject {

}

extension DateComponentsAccessing {
    var dateFormatter: DateFormatter {
         return SharedDateFormatter.dateFormatter
    }

    var calendar: Calendar {
        return SharedCalendar.calendar
    }
}

final class SharedDateFormatter {
    static let dateFormatter = DateFormatter()
}

final class SharedCalendar {

    static var calendar: Calendar {

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(abbreviation: "GMT")!
        calendar.locale = Locale.current

        return calendar
    }
}

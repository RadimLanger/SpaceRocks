//
//  String+FirstThreeCharsAfterDot.swift
//  Space Rocks
//
//  Created by Radim Langer on 10/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

extension String {
    func firstThreeCharactersAfterDot() -> String {
        let components = self.components(separatedBy: ".")
        if components.count > 1 {
            return components[0] + "." + components[1].prefix(3)
        }
        return components[0]
    }
}

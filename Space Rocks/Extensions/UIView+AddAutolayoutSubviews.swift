//
//  UIView+AddAutolayoutSubviews.swift
//  Space Rocks
//
//  Created by Radim Langer on 07/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import UIKit

extension UIView {
    func addAutolayoutSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
}

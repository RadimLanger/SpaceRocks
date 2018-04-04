//
//  StoryboardExtension.swift
//  Space Rocks
//
//  Created by Radim Langer on 04/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func instantiateViewController<ViewController>(type: ViewController.Type) -> ViewController {

        let name = String(describing: type)

        return UIStoryboard(name: name + "Storyboard", bundle: nil).instantiateViewController(withIdentifier: name) as! ViewController
    }
}

//
//  AlertManager.swift
//  Space Rocks
//
//  Created by Radim Langer on 10/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import UIKit

final class AlertManager {

    public static var noInternetConnectionAlert: UIAlertController = {
        let alertController = UIAlertController(
            title: "No internet connection",
            message: "Will be refreshed automatically when connection is established.",
            preferredStyle: .alert
        )

        let dismissAction = UIAlertAction(title: "OK", style: .default) { action in
            alertController.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(dismissAction)
        return alertController
    }()
}


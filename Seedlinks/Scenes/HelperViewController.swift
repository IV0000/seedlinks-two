//
//  HelperViewController.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 27/04/23.
//

import Foundation
import UIKit

class HelperViewController: UIViewController {
    func showGoToSettingsAlert() {
        let alertController = UIAlertController(title: "Location disabled",
                                                message: "Go to settings to enable location",
                                                preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}

//
//  TabBar.swift
//  Seedlinks
//
//  Created by Ivan Voloshchuk on 12/04/23.
//

import UIKit

class TabBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tabBar.isTranslucent = false
        tabBar.tintColor = .label
        setupVCs()
    }

    func setupVCs() {
        viewControllers = [
            createNavController(for: MapViewController(), title: "Seeds", image: UIImage(systemName: "map")!),
            createNavController(for: GardenViewController(), title: "Garden", image: UIImage(systemName: "tree")!)
        ]
    }

    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.isHidden = true
        return navController
    }
}

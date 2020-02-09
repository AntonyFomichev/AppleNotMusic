//
//  MainTabBarController.swift
//  AppleNotMusic
//
//  Created by Антон on 09.02.2020.
//  Copyright © 2020 Tony Blaire. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    let libraryVC = ViewController()
    
    viewControllers = [
      generateViewController(rootViewController: libraryVC, image: #imageLiteral(resourceName: "ios10-apple-music-library-5nav-icon-1"), title: "Library"),
      generateViewController(rootViewController: searchVC, image: #imageLiteral(resourceName: "ios10-apple-music-search-5nav-icon-1"), title: "Search")
    ]
  }
  
  private func generateViewController(rootViewController: UIViewController, image: UIImage, title: String) -> UIViewController {
    let navigationVC = UINavigationController(rootViewController: rootViewController)
    navigationVC.tabBarItem.image = image
    navigationVC.tabBarItem.title = title
    rootViewController.navigationItem.title = title
    navigationVC.navigationBar.prefersLargeTitles = true

    return navigationVC
  }
  
}

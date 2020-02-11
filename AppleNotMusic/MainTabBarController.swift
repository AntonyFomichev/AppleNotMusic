//
//  MainTabBarController.swift
//  AppleNotMusic
//
//  Created by Антон on 09.02.2020.
//  Copyright © 2020 Tony Blaire. All rights reserved.
//

import UIKit


protocol MainTabBarControllerDelegate: class {
  func minimizeTrackDetailController()
  func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?)
}


class MainTabBarController: UITabBarController {
  
  let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let searchVC: SearchViewController = SearchViewController.loadFromStoryboard()
    let libraryVC = ViewController()
    
    setupTrackDetailView()
    searchVC.tabBarDelegate = self
    
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
  
  private var minimizedTopAnchorConstraint: NSLayoutConstraint!
  private var maximizedTopAnchorConstraint: NSLayoutConstraint!
  private var bottomAnchorConstraint: NSLayoutConstraint!
  
  private func setupTrackDetailView() {

    view.insertSubview(trackDetailView, belowSubview: tabBar)
    trackDetailView.translatesAutoresizingMaskIntoConstraints = false
    trackDetailView.tabBarDelegate = self
    minimizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
    maximizedTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
    bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
    bottomAnchorConstraint.isActive = true
    maximizedTopAnchorConstraint.isActive = true
    
    trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
  }
}

extension MainTabBarController: MainTabBarControllerDelegate {
  func maximizeTrackDetailController(viewModel: SearchViewModel.Cell?) {
    maximizedTopAnchorConstraint.isActive = true
    minimizedTopAnchorConstraint.isActive = false
    maximizedTopAnchorConstraint.constant = 0
    bottomAnchorConstraint.constant = 0
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.view.layoutIfNeeded()
      self.tabBar.alpha = 0
    }, completion: nil)
    
    guard let viewModel = viewModel else {return }
    
    self.trackDetailView.set(viewModel: viewModel)
  }
  
  func minimizeTrackDetailController() {
    maximizedTopAnchorConstraint.isActive = false
    bottomAnchorConstraint.constant = view.frame.height
    minimizedTopAnchorConstraint.isActive = true
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.view.layoutIfNeeded()
      self.tabBar.alpha = 1
    }, completion: nil)
  }
  
  
}

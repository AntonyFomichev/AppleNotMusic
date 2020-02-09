//
//  UIViewController.swift
//  AppleNotMusic
//
//  Created by Антон on 09.02.2020.
//  Copyright © 2020 Tony Blaire. All rights reserved.
//

import UIKit

extension UIViewController {
  class func loadFromStoryboard<T: UIViewController>() -> T {
    let name = String(describing: T.self)
    let storyboard = UIStoryboard(name: name, bundle: nil)
    
    if let viewController = storyboard.instantiateInitialViewController() as? T {
      return viewController
    } else {
      fatalError("Error: no initial view controller in \(name) storyboard")
    }
  }
}

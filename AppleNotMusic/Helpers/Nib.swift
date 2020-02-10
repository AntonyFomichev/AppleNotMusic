//
//  Nib.swift
//  AppleNotMusic
//
//  Created by Антон on 10.02.2020.
//  Copyright © 2020 Tony Blaire. All rights reserved.
//

import UIKit

extension UIView {
  class func loadFromNib<T: UIView>() -> T {
    return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)?[0] as! T
  }
}

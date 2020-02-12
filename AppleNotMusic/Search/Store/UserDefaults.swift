//
//  UserDefaults.swift
//  AppleNotMusic
//
//  Created by Антон on 12.02.2020.
//  Copyright © 2020 Tony Blaire. All rights reserved.
//

import Foundation

extension UserDefaults {
  static let favouriteTrackKey = "favouriteTrackKey"
  
  func getSavedTracks() -> [SearchViewModel.Cell] {
    let defaults = UserDefaults.standard
    guard let savedTracks = defaults.object(forKey: UserDefaults.favouriteTrackKey) as? Data else { return [] }
    
    guard let decodedTracks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTracks) as? [SearchViewModel.Cell] else {return [] }
    
    return decodedTracks
  }
}

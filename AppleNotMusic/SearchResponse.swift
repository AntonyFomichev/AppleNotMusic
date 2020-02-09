//
//  SearchResponse.swift
//  AppleNotMusic
//
//  Created by Антон on 09.02.2020.
//  Copyright © 2020 Tony Blaire. All rights reserved.
//

import Foundation


struct SearchResponse: Decodable {
  var resultCount: Int
  var results: [Track]
}

struct Track: Decodable {
  var trackName: String?
  var artistName: String
  var collectionName: String?
  var artworkUrl100: String?
  var previewUrl: String?
}

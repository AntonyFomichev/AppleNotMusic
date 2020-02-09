//
//  SearchModels.swift
//  AppleNotMusic
//
//  Created by Антон on 09.02.2020.
//  Copyright (c) 2020 Tony Blaire. All rights reserved.
//

import UIKit

enum Search {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getTracks(searchText: String)
        
      }
    }
    struct Response {
      enum ResponseType {
        case presentTracks(searchResponse: SearchResponse?)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayTracks(searchViewModel: SearchViewModel)
      }
    }
  }
  
}

struct SearchViewModel {
  struct Cell: TrackCellViewModel {
    var iconUrlString: String?
    var trackName: String?
    var collectionName: String
    var artistName: String
    var previewUrl: String?
  }
  
  let cells: [Cell]
}

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
        case some
        case getTracks
        
      }
    }
    struct Response {
      enum ResponseType {
        case some
        case presentTracks
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case some
        case displayTracks
      }
    }
  }
  
}

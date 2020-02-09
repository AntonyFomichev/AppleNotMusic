//
//  SearchInteractor.swift
//  AppleNotMusic
//
//  Created by Антон on 09.02.2020.
//  Copyright (c) 2020 Tony Blaire. All rights reserved.
//

import UIKit

protocol SearchBusinessLogic {
  func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {

  var presenter: SearchPresentationLogic?
  var service: SearchService?
  
  func makeRequest(request: Search.Model.Request.RequestType) {
    if service == nil {
      service = SearchService()
    }
    
    switch request {
    case .some:
      print("interactor .some")
      presenter?.presentData(response: .presentTracks)
    case .getTracks:
      print("interactor .getTracks")
      presenter?.presentData(response: .presentTracks)
    }
  }
  
}

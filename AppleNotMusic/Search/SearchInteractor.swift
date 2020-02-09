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

  var networkService = NetworkService()
  var presenter: SearchPresentationLogic?
  var service: SearchService?
  
  func makeRequest(request: Search.Model.Request.RequestType) {
    if service == nil {
      service = SearchService()
    }
    
    switch request {
    case .getTracks(let searchText):
      networkService.fetchTracks(searchText: searchText) { [weak self] (searchResponse) in
        self?.presenter?.presentData(response: .presentTracks(searchResponse: searchResponse))
      }
    }
  }
}

//
//  SearchPresenter.swift
//  AppleNotMusic
//
//  Created by Антон on 09.02.2020.
//  Copyright (c) 2020 Tony Blaire. All rights reserved.
//

import UIKit

protocol SearchPresentationLogic {
  func presentData(response: Search.Model.Response.ResponseType)
}

class SearchPresenter: SearchPresentationLogic {
  weak var viewController: SearchDisplayLogic?
  
  func presentData(response: Search.Model.Response.ResponseType) {
    switch response {
    case .some:
      print("presenter .some")
    case .presentTracks:
      print("presenter .presentTracks")
      viewController?.displayData(viewModel: .displayTracks)
    }
  }
  
}

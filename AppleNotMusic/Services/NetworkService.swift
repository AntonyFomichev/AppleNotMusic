//
//  NetworkService.swift
//  AppleNotMusic
//
//  Created by Антон on 09.02.2020.
//  Copyright © 2020 Tony Blaire. All rights reserved.
//

import UIKit
import Alamofire

class NetworkService {
  func fetchTracks(searchText: String, completion: @escaping (SearchResponse?) -> Void) {
    let url = "https://itunes.apple.com/search"
    let params = ["term": "\(searchText)", "limit": "10", "media": "music"]
    
    AF.request(url, method: .get, parameters: params).responseData {
      (dataRes) in
      if let error = dataRes.error {
        print("\(error.localizedDescription)")
        completion(nil)
        return
      }
      
      guard let data = dataRes.data else {return }
      
      let decoder = JSONDecoder()
      do {
        let objects = try decoder.decode(SearchResponse.self, from: data)
        completion(objects)
      } catch let jsonError {
        print(jsonError)
        completion(nil)
      }
    }
  }
}

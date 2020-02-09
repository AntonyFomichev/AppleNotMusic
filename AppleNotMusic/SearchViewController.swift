//
//  SearchViewController.swift
//  AppleNotMusic
//
//  Created by Антон on 09.02.2020.
//  Copyright © 2020 Tony Blaire. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UITableViewController {
  
  private var timer: Timer?
  let searchController = UISearchController(searchResultsController: nil)

  var tracks = [Track]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSearchBar()

    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
  }
  
  private func setupSearchBar() {
    navigationItem.searchController = searchController
    searchController.searchBar.delegate = self
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tracks .count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier:  "cellId", for: indexPath)
    let track = tracks[indexPath.row]
    cell.textLabel?.text = "\(track.trackName ?? "Unnamed")\n\(track.artistName)"
    cell.textLabel?.numberOfLines = 2
    cell.imageView?.image = #imageLiteral(resourceName: "Image")

    return cell
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
      let url = "https://itunes.apple.com/search"
      let params = ["term": "\(searchText)", "limit": "10"]
      
      AF.request(url, method: .get, parameters: params).responseData {
        (dataRes) in
        if let error = dataRes.error {
          print("\(error.localizedDescription)")
          return
        }
        
        guard let data = dataRes.data else {return }
        
        let decoder = JSONDecoder()
        do {
          let objects = try decoder.decode(SearchResponse.self, from: data)
          self.tracks = objects.results
          self.tableView.reloadData()
        } catch let jsonError {
          print(jsonError)
        }
      }
    })
  }
}

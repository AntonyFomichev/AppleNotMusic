//
//  SearchViewController.swift
//  AppleNotMusic
//
//  Created by Антон on 09.02.2020.
//  Copyright © 2020 Tony Blaire. All rights reserved.
//

import UIKit

struct TrackModel {
  var trackName: String
  var artistName: String
}

class SearchViewController: UITableViewController {
  let searchController = UISearchController(searchResultsController: nil)
  
  let tracks = [TrackModel(trackName: "Bad Guy", artistName: "Billie Eilish"), TrackModel(trackName: "Нужен Xanax", artistName: "Паша Техник")]
  
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
    cell.textLabel?.text = "\(track.trackName)\n\(track.artistName)"
    cell.textLabel?.numberOfLines = 2
    cell.imageView?.image = #imageLiteral(resourceName: "Image")

    return cell
  }
}

extension SearchViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      print(searchText)
  }
}

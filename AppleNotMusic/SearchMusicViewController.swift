//
//  SearchViewController.swift
//  AppleNotMusic
//
//  Created by Антон on 09.02.2020.
//  Copyright © 2020 Tony Blaire. All rights reserved.
//

import UIKit

class SearchMusicViewController: UITableViewController {
  
  var networkService = NetworkService()
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

extension SearchMusicViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
      self.networkService.fetchTracks(searchText: searchText) { [weak self] (searchResults) in
        self?.tracks = searchResults?.results ?? []
        self?.tableView.reloadData()
      }
    })
  }
}

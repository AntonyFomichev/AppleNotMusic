//
//  SearchViewController.swift
//  AppleNotMusic
//
//  Created by Антон on 09.02.2020.
//  Copyright (c) 2020 Tony Blaire. All rights reserved.
//

import UIKit

protocol SearchDisplayLogic: class {
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData)
}

class SearchViewController: UIViewController, SearchDisplayLogic {
  
  var interactor: SearchBusinessLogic?
  var router: (NSObjectProtocol & SearchRoutingLogic)?
  
  @IBOutlet weak var table: UITableView!
  
  let searchController = UISearchController(searchResultsController: nil)
  private var searchViewModel = SearchViewModel.init(cells: [])
  private var timer: Timer?
  
  // MARK: Setup
  
  private func setup() {
    let viewController        = self
    let interactor            = SearchInteractor()
    let presenter             = SearchPresenter()
    let router                = SearchRouter()
    viewController.interactor = interactor
    viewController.router     = router
    interactor.presenter      = presenter
    presenter.viewController  = viewController
    router.viewController     = viewController
  }
  
  // MARK: Routing
  
  
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupTableView()
    setupSearchBar()
  }
  
  private func setupSearchBar() {
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.delegate = self
  }
  
  private func setupTableView() {
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    let nib = UINib(nibName: "TrackCell", bundle: nil)
    table.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
  }
  
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
    switch viewModel {
    case .displayTracks(let searchViewModel):
      self.searchViewModel = searchViewModel
      table.reloadData()
    }
  }
  
}

// MARK: -

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchViewModel.cells.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = table.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as! TrackCell
    
    let cellViewModel = searchViewModel.cells[indexPath.row]
    cell.trackImageView.backgroundColor = .gray
    
    cell.set(viewModel: cellViewModel)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 84
  }
}


extension SearchViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
      self.interactor?.makeRequest(request: .getTracks(searchText: searchText))
    })
  }
}

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
  private lazy var footerView = FooterView()
  weak var tabBarDelegate: MainTabBarControllerDelegate?

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
    table.tableFooterView = footerView
    let nib = UINib(nibName: "TrackCell", bundle: nil)
    table.register(nib, forCellReuseIdentifier: TrackCell.reuseId)
  }
  
  func displayData(viewModel: Search.Model.ViewModel.ViewModelData) {
    switch viewModel {
    case .displayTracks(let searchViewModel):
      self.searchViewModel = searchViewModel
      table.reloadData()
      footerView.hideLoader()
    case .displayFooterView:
      footerView.showLoader()
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
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let label = UILabel()
    label.text = "This search is empty 🤷"
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    return label
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cellViewModel = searchViewModel.cells[indexPath.row]
    
    tabBarDelegate?.maximizeTrackDetailController(viewModel: cellViewModel)
    
//    let keyWindow = UIApplication.shared.connectedScenes
//      .filter({$0.activationState == .foregroundActive})
//      .map({$0 as? UIWindowScene})
//      .compactMap({$0})
//      .first?.windows
//      .filter({$0.isKeyWindow}).first
//    let window = keyWindow
//    let trackDetailsView: TrackDetailView = TrackDetailView.loadFromNib()
//    trackDetailsView.delegate = self
//    trackDetailsView.set(viewModel: cellViewModel)
//    window?.addSubview(trackDetailsView)
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return searchViewModel.cells.count > 0 ? 0 : 40
    
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


extension SearchViewController: TrackMovingDelegate {
  
  private func getTrack(isForwardTrack: Bool) ->SearchViewModel.Cell? {
    guard let indexPath = table.indexPathForSelectedRow else {return nil}
    table.deselectRow(at: indexPath, animated: true)
    var nextIndexPath: IndexPath!
    if isForwardTrack {
      nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
      if nextIndexPath.row == searchViewModel.cells.count {
        nextIndexPath.row = 0
      }
    } else {
      nextIndexPath = IndexPath.init(row: indexPath.row - 1, section: indexPath.section)
      if nextIndexPath.row == -1 {
        nextIndexPath.row = searchViewModel.cells.count - 1
      }
    }
    
    table.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
    let cellViewModel = searchViewModel.cells[nextIndexPath.row]
    return cellViewModel
    
  }
  
  func moveBackForPreviousTrack() -> SearchViewModel.Cell? {
    return getTrack(isForwardTrack: false)
  }
  
  func moveForwardForNextTrack() -> SearchViewModel.Cell? {
    return getTrack(isForwardTrack: true)
  }
}

//
//  TrackCell.swift
//  AppleNotMusic
//
//  Created by Антон on 09.02.2020.
//  Copyright © 2020 Tony Blaire. All rights reserved.
//

import UIKit
import SDWebImage


protocol TrackCellViewModel {
  var iconUrlString: String? {get}
  var trackName: String? {get}
  var artistName: String {get}
  var collectionName: String {get}
} 

class TrackCell: UITableViewCell {
  
  static let reuseId = "TrackCell"
  
  @IBOutlet weak var trackImageView: UIImageView!
  @IBOutlet weak var trackNameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var collectionNameLabel: UILabel!
  
  @IBOutlet weak var buttonAddTrack: UIButton!
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    trackImageView.image = nil
  }
  
  var cell: SearchViewModel.Cell?
  
  func isTrackAdded() -> Bool {
    let savedTracks = UserDefaults.standard.getSavedTracks()
    let isAdded = savedTracks.firstIndex(where: {
      $0.trackName == self.cell?.trackName && $0.artistName == self.cell?.artistName
    }) != nil
    
    return isAdded
  }
  
  func set(viewModel: SearchViewModel.Cell) {
    self.cell = viewModel
    
    if (isTrackAdded()) {
      buttonAddTrack.isHidden = true
    } else {
      buttonAddTrack.isHidden = false
    }
    
    trackNameLabel.text = viewModel.trackName
    artistNameLabel.text = viewModel.artistName
    collectionNameLabel.text = viewModel.collectionName
    
    guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
    trackImageView.sd_setImage(with: url, completed: nil)
  }
  
  @IBAction func addTrackAction(_ sender: Any) {
    let defaults = UserDefaults.standard
    guard let cell = cell else { return }
    
    buttonAddTrack.isHidden = true
    
    var trackList = defaults.getSavedTracks()
    trackList.append(cell)
    
    if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: trackList, requiringSecureCoding: false) {
      defaults.set(saveData, forKey: UserDefaults.favouriteTrackKey)
      print("Done!")
    }
  }
}

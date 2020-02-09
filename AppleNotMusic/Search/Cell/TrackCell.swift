//
//  TrackCell.swift
//  AppleNotMusic
//
//  Created by Антон on 09.02.2020.
//  Copyright © 2020 Tony Blaire. All rights reserved.
//

import UIKit

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
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func set(viewModel: TrackCellViewModel) {
    trackNameLabel.text = viewModel.trackName
    artistNameLabel.text = viewModel.artistName
    collectionNameLabel.text = viewModel.collectionName
  }
}

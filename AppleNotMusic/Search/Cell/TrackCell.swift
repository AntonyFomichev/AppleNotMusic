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
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    trackImageView.image = nil
  }
  
  var cell: SearchViewModel.Cell?
  
  func set(viewModel: SearchViewModel.Cell) {
    self.cell = viewModel
    
    trackNameLabel.text = viewModel.trackName
    artistNameLabel.text = viewModel.artistName
    collectionNameLabel.text = viewModel.collectionName
    
    guard let url = URL(string: viewModel.iconUrlString ?? "") else { return }
    trackImageView.sd_setImage(with: url, completed: nil)
  }
  
  @IBAction func addTrackAction(_ sender: Any) {
    let defaults = UserDefaults.standard
    if let saveData = try? NSKeyedArchiver.archivedData(withRootObject: cell ?? {}, requiringSecureCoding: false) {
      defaults.set(saveData, forKey: "tracks")
      print("Done!")
    }
  }
}

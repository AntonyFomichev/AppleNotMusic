//
//  TrackDetailView.swift
//  AppleNotMusic
//
//  Created by Антон on 10.02.2020.
//  Copyright © 2020 Tony Blaire. All rights reserved.
//

import UIKit
import AVKit
import SDWebImage

class TrackDetailView:UIView {
  @IBOutlet weak var trackImageView: UIImageView!
  @IBOutlet weak var currentTimeSlider: UISlider!
  @IBOutlet weak var currentTimeLabel: UILabel!
  @IBOutlet weak var durationLabel: UILabel!
  @IBOutlet weak var trackTitleLabel: UILabel!
  @IBOutlet weak var authorTitleLabel: UILabel!
  @IBOutlet weak var playPauseButton: UIButton!
  @IBOutlet weak var volumeSlider: UISlider!
  
  let player: AVPlayer = {
    let avPlayer = AVPlayer()
    avPlayer.automaticallyWaitsToMinimizeStalling = false
    return avPlayer
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    trackImageView.backgroundColor = .gray
  }
  
  func set(viewModel: SearchViewModel.Cell) {
    trackTitleLabel.text = viewModel.trackName
    authorTitleLabel.text = viewModel.artistName
    playTrack(preview: viewModel.previewUrl)
    
    let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
    guard let url = URL(string: string600 ?? "") else { return }
    trackImageView!.sd_setImage(with: url, completed: nil)
  }
  
  private func playTrack(preview: String?) {
    print("")
    
    guard let url = URL(string: preview ?? "") else { return }
    let playerItem = AVPlayerItem(url: url)
    player.replaceCurrentItem(with: playerItem)
    player.play()
  }
  
  @IBAction func dragDownButtonTapped(_ sender: Any) {
    self.removeFromSuperview()
  }
  
  @IBAction func handleCurrentTimeSlider(_ sender: Any) {
  }
  
  @IBAction func handleVolumeSlider(_ sender: Any) {
  }
  
  @IBAction func previousTrack(_ sender: Any) {
  }
  
  @IBAction func nextTrack(_ sender: Any) {
  }
  
  @IBAction func playPauseAction(_ sender: Any) {
    if (player.timeControlStatus == .paused) {
      player.play()
      playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
    } else {
      player.pause()
      playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
    }
  }
  
}

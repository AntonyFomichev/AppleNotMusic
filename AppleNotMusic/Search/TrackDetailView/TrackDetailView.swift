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

protocol TrackMovingDelegate: class {
  func moveBackForPreviousTrack() -> SearchViewModel.Cell?
  func moveForwardForNextTrack() -> SearchViewModel.Cell?
}

class TrackDetailView:UIView {
  @IBOutlet weak var miniTrackView: UIView!
  @IBOutlet weak var miniGoForwardButton: UIButton!
  @IBOutlet weak var miniTrackImageView: UIImageView!
  @IBOutlet weak var miniTrackTitleLabel: UILabel!
  @IBOutlet weak var miniPlayPauseButton: UIButton!
  
  @IBOutlet weak var maximizedStackView: UIStackView!
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
  
  weak var delegate: TrackMovingDelegate?
  weak var tabBarDelegate: MainTabBarControllerDelegate?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    let scale: CGFloat = 0.8
    trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
    
    trackImageView.layer.cornerRadius = 5
    trackImageView.backgroundColor = .gray
    
    miniPlayPauseButton.imageEdgeInsets = .init(top: 11, left: 11, bottom: 11, right: 11)
    
    setupGestures()
  }
  
  func set(viewModel: SearchViewModel.Cell) {
    miniTrackTitleLabel.text = viewModel.trackName
    trackTitleLabel.text = viewModel.trackName
    authorTitleLabel.text = viewModel.artistName
    playTrack(preview: viewModel.previewUrl)
    monitorStartTime()
    observeLayerCurrentTime()
    playPauseButton.setImage(#imageLiteral(resourceName: "Pause-1"), for: .normal)
    miniPlayPauseButton.setImage(#imageLiteral(resourceName: "Pause-1"), for: .normal)
    let string600 = viewModel.iconUrlString?.replacingOccurrences(of: "100x100", with: "600x600")
    guard let url = URL(string: string600 ?? "") else { return }
    miniTrackImageView.sd_setImage(with: url, completed: nil)
    trackImageView.sd_setImage(with: url, completed: nil)
  }
  
  private func setupGestures() {
    miniTrackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMaximized)))
    miniTrackView.addGestureRecognizer(UIPanGestureRecognizer(target:self, action: #selector(handlePan)))
    addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
  }
  
  @objc private func handleMaximized() {
    self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
  }
  
  @objc private func handlePan(gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .began:
      print("began")
    case .changed:
      handlePanChange(gesture: gesture)
    case .ended:
      handlePanEnded(gesture: gesture)
    case .possible:
      print("")
    case .cancelled:
      print("")
      
    case .failed:
      print("")
      
    @unknown default:
      print("unknown")
    }
  }
  
  
  @objc private func handleDismissalPan(gesture: UIPanGestureRecognizer) {
    switch gesture.state {
    case .possible:
           print("")
    case .began:
           print("")
    case .changed:
      let translation = gesture.translation(in: self.superview)
      maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
    case .ended:
      let translation = gesture.translation(in: self.superview)
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
        self.maximizedStackView.transform = .identity
        if translation.y > 50 {
          self.tabBarDelegate?.minimizeTrackDetailController()
        }
      }, completion: nil)
    case .cancelled:
           print("")
    case .failed:
           print("")
    @unknown default:
      print("")
    }
  }
  
  private func handlePanChange(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: self.superview)
    self.transform = CGAffineTransform(translationX: 0, y: translation.y)
    
    let newAlpha = 1 + translation.y / 200
    self.miniTrackView.alpha = newAlpha < 0 ? 0 : newAlpha
    self.maximizedStackView.alpha = -translation.y / 200
  }
  
  private func handlePanEnded(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: self.superview)
    let velocity = gesture.velocity(in: self.superview)
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.transform = .identity
      if translation.y < -200 || velocity.y < -500 {
        self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
      } else {
        self.miniTrackView.alpha = 1
        self.maximizedStackView.alpha = 0
      }
    }, completion: nil)
  }
  
  private func playTrack(preview: String?) {
    guard let url = URL(string: preview ?? "") else { return }
    let playerItem = AVPlayerItem(url: url)
    player.replaceCurrentItem(with: playerItem)
    player.play()
  }
  
  //MARK: - Animations
  
  private func monitorStartTime() {
    let time = CMTimeMake(value: 1, timescale: 3)
    let times = [NSValue(time: time)]
    player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
      self?.enlargeImageView()
    }
  }
  
  private func observeLayerCurrentTime() {
    let time = CMTimeMake(value: 1, timescale: 2)
    player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] (time) in
      self?.currentTimeLabel.text = time.toString()
      let durationTime = self?.player.currentItem?.duration
      let currentDurationTimeText = ((durationTime ?? CMTimeMake(value: 1, timescale: 1)) - time).toString()
      self?.durationLabel.text = currentDurationTimeText
      self?.updateCurrentTimeSlider()
    }
  }
  
  private func updateCurrentTimeSlider() {
    let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
    let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
    let percentage = currentTimeSeconds / durationSeconds
    self.currentTimeSlider.value = Float(percentage)
  }
  
  private func enlargeImageView() {
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      self.trackImageView.transform = .identity
    }, completion: nil)
  }
  
  private func reduceImageView() {
    UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
      let scale: CGFloat = 0.8
      self.trackImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }, completion: nil)
  }
  
  //MARK: - @IBActions
  
  @IBAction func dragDownButtonTapped(_ sender: Any) {
    self.tabBarDelegate?.minimizeTrackDetailController()
  }
  
  @IBAction func handleCurrentTimeSlider(_ sender: Any) {
    let percentage = currentTimeSlider.value
    guard let duration = player.currentItem?.duration else { return }
    let durationInSeconds = CMTimeGetSeconds(duration)
    let seekTimeInSeconds = Float64(percentage) * durationInSeconds
    let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
    player.seek(to: seekTime)
  }
  
  @IBAction func handleVolumeSlider(_ sender: Any) {
    player.volume = volumeSlider.value
  }
  
  @IBAction func previousTrack(_ sender: Any) {
    let cellViewModel = delegate?.moveBackForPreviousTrack()
    guard let cellInfo = cellViewModel else { return }
    self.set(viewModel: cellInfo)
  }
  
  @IBAction func nextTrack(_ sender: Any) {
    let cellViewModel = delegate?.moveForwardForNextTrack()
    guard let cellInfo = cellViewModel else { return }
    self.set(viewModel: cellInfo)
  }
  
  @IBAction func playPauseAction(_ sender: Any) {
    if (player.timeControlStatus == .paused) {
      player.play()
      playPauseButton.setImage(#imageLiteral(resourceName: "Pause-1"), for: .normal)
      miniPlayPauseButton.setImage(#imageLiteral(resourceName: "Pause-1"), for: .normal)
      enlargeImageView()
    } else {
      player.pause()
      playPauseButton.setImage(#imageLiteral(resourceName: "play-1"), for: .normal)
      miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play-1"), for: .normal)
      reduceImageView()
    }
  }
}

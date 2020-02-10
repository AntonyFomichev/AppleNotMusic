//
//  CMTimeExt.swift
//  AppleNotMusic
//
//  Created by Антон on 10.02.2020.
//  Copyright © 2020 Tony Blaire. All rights reserved.
//

import AVKit

extension CMTime {
  func toString() -> String {
    guard !CMTimeGetSeconds(self).isNaN else {return ""}
    let totalSeconds = Int(CMTimeGetSeconds(self))
    let seconds = totalSeconds % 60
    let minutes = totalSeconds / 60
    let time = String(format: "%02d:%02d", minutes, seconds)
    return time
  }
}

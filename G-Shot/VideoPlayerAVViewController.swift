//
//  VideoPlayerAVViewController.swift
//  G-Shot
//
//  Created by Artem Orynko on 5/21/17.
//  Copyright © 2017 GoTo Inc. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayerAVViewController: AVPlayerViewController {

  var url: URL!

    override func viewDidLoad() {
        super.viewDidLoad()

      player = AVPlayer(url: url)

      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleShare))
    }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    player?.play()
  }

  func handleShare() {
    let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: [])
    present(activityVC, animated: true)
  }
}

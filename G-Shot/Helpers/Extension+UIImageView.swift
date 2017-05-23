//
//  Extension+UIImageView.swift
//  G-Shot
//
//  Created by Artem Orynko on 5/18/17.
//  Copyright © 2017 GoTo Inc. All rights reserved.
//

import UIKit
import CoreMedia

extension UIImageView {
  func imageFrame(offSetX: CGFloat, offSetY: CGFloat) -> CGRect {

    let imageViewSize = frame.size

    guard let imageSize = image?.size else {
      return .zero
    }
    let scaleFactor = imageViewSize.height / imageSize.height
    let width = imageSize.width * scaleFactor

    return CGRect(x: offSetX, y: offSetY, width: width, height: width)
  }
}

extension CMTime {
  var durationText: String {
    let totalSeconds = CMTimeGetSeconds(self)
    let seconds: Int = Int(totalSeconds .truncatingRemainder(dividingBy: 60))
    return String(format: "%02i sec", seconds)
  }
}

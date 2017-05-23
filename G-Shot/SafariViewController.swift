//
//  SafariViewController.swift
//  G-Shot
//
//  Created by Artem Orynko on 5/22/17.
//  Copyright © 2017 GoTo Inc. All rights reserved.
//

import UIKit
import SafariServices

class SafariViewController: SFSafariViewController {

  override func viewDidLoad() {
        super.viewDidLoad()

    navigationController?.navigationBar.isHidden = true

    navigationItem.leftBarButtonItem?.title = "Back"
    }


  override var prefersStatusBarHidden: Bool {
    return true
  }
}

//
//  PhotoPreviewViewController.swift
//  G-Shot
//
//  Created by Artem Orynko on 5/21/17.
//  Copyright © 2017 GoTo Inc. All rights reserved.
//

import UIKit

class PhotoPreviewViewController: UIViewController {

  var image: UIImage!

  lazy var imageView: UIImageView = {
    let imageView = UIImageView(image: self.image)
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.backgroundColor = .clear
    imageView.contentMode = .scaleAspectFit

    return imageView
  }()

    override func viewDidLoad() {
        super.viewDidLoad()

      view.backgroundColor = .black
      navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleShare))

      view.addSubview(imageView)

      imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
      imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
      imageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        // Do any additional setup after loading the view.
    }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false

  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.hidesBarsOnSwipe = false
  }

  func handleShare() {
    let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: [])
    present(activityVC, animated: true)
  }
}

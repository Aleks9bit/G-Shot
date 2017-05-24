//
//  LibraryCollectionViewController.swift
//  G-Shot
//
//  Created by Artem Orynko on 5/21/17.
//  Copyright © 2017 GoTo Inc. All rights reserved.
//

import UIKit
import Photos
import CoreMedia
import AVKit

private let reuseIdentifier = "Cell"

class LibraryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

  var album: PHAssetCollection!

  lazy var assets: PHFetchResult<PHAsset> = {
    return PHAsset.fetchAssets(in: self.album, options: nil)
  }()
  var selectedAssets = [String: PHAsset]()

    override func viewDidLoad() {
        super.viewDidLoad()

      navigationController?.hidesBarsOnSwipe = true
      navigationItem.title = "Green Book"


      collectionView?.backgroundColor = .white
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
    navigationController?.isToolbarHidden = true
  }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return assets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photo", for: indexPath)
    
      let asset = self.assets[indexPath.row] as PHAsset
      let thumbnail = getAssetThumbnail(asset: asset)
      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
      imageView.image = thumbnail
      imageView.contentMode = .scaleAspectFill
      cell.addSubview(imageView)
      cell.sendSubview(toBack: imageView)

      if asset.mediaType == .video {

        let detailView = UIView(frame: CGRect(x: 10, y: 0, width: cell.frame.width - 10, height: 20))
        detailView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

        let durationLabel = UILabel(frame: CGRect(x: 0, y: detailView.frame.height, width: detailView.frame.width, height: 20))
        durationLabel.textColor = .black
        fetchAVAssetForPHAsset(videoAsset: asset, complition: { (success, url) in
          if success {
            let avasset = AVAsset(url: url)
            let duration = avasset.duration.durationText
            DispatchQueue.main.async {
              durationLabel.text = duration
            }
          }
        })
        detailView.addSubview(durationLabel)
        cell.addSubview(detailView)
        
      }
        return cell
    }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath)-> CGSize {
    let size = collectionView.bounds.size.width / 4 - 10
    return CGSize(width: size, height: size)
  }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
      let asset = self.assets[indexPath.row] as PHAsset
      if asset.mediaType == .video {
        fetchAVAssetForPHAsset(videoAsset: asset, complition: { (success, url) in
          if success {
            let playerController = VideoPlayerAVViewController()
            playerController.url = url

            DispatchQueue.main.async {
              self.navigationController?.pushViewController(playerController, animated: true)

            }
          }
        })
      } else {
        PHImageManager.default().requestImageData(for: asset, options: nil, resultHandler: { (data, _, _, _) in
          if let image = UIImage(data: data!) {
            let previewPhotoVC = PhotoPreviewViewController()
            previewPhotoVC.image = image

            DispatchQueue.main.async {
              self.navigationController?.pushViewController(previewPhotoVC, animated: true)
            }
          }
        })
      }
        return true
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

  func fetchAVAssetForPHAsset(videoAsset: PHAsset, complition: @escaping (Bool, URL) -> Void) {
    let options = PHVideoRequestOptions()
    options.deliveryMode = .highQualityFormat
    PHImageManager.default().requestAVAsset(forVideo: videoAsset, options: options) { (asset, audioMix, dict) in
      let url = (asset as! AVURLAsset).url
      complition(true, url)
    }
  }

  func getAssetThumbnail(asset: PHAsset) -> UIImage {
    let manager = PHImageManager.default()
    let options = PHImageRequestOptions()
    var thumbnail = UIImage()

    options.isSynchronous = true
    manager.requestImage(for: asset, targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: options) { (result, info) in
      thumbnail = result!
    }
    return thumbnail
  }
}

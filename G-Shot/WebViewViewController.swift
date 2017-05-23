//
//  WebViewViewController.swift
//  G-Book
//
//  Created by Artem Orynko on 5/23/17.
//  Copyright © 2017 GoTo Inc. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {

  var url: URL?
  var webView: WKWebView?


  let backBarButton: UIBarButtonItem = {
    let image = UIImage(imageLiteralResourceName: "back")
    let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleBack))
    barButton.isEnabled = false

    return barButton
  }()

  let forwardBarButton: UIBarButtonItem = {
    let image = UIImage(imageLiteralResourceName: "forward")
    let barButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleForward))
    barButton.isEnabled = false

    return barButton
  }()

  let flex: UIBarButtonItem = {
    return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
  }()

  let reload: UIBarButtonItem = {
    return UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(handleReload))
  }()


  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
    navigationController?.isToolbarHidden = false
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    navigationController?.navigationBar.isHidden = true
    navigationController?.isToolbarHidden = true

    webView?.removeObserver(self, forKeyPath: "loading")
  }

  func setupViews() {

    view.backgroundColor = .clear

    navigationController?.navigationItem.rightBarButtonItem?.tintColor = secondColor

    webView = WKWebView()
    self.view = webView
    webView?.allowsBackForwardNavigationGestures = true
    webView?.addObserver(self, forKeyPath: "loading", options: .new, context: nil)

    let request = URLRequest(url: url!)
    webView?.load(request)





    DispatchQueue.main.async {
      self.navigationController?.toolbar.items = [self.forwardBarButton, self.backBarButton, self.flex, self.reload]
    }
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    if keyPath == "loading" {
      backBarButton.isEnabled = (webView?.canGoBack)!
      forwardBarButton.isEnabled = (webView?.canGoForward)!
    }
  }

  func handleReload() {
    webView?.reload()
  }

  func handleBack() {
    webView?.goBack()
  }
  func handleForward() {
    webView?.goForward()
  }
}

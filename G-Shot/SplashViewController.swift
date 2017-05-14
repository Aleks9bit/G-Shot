//
//  SplashViewController.swift
//  G-Shot
//
//  Created by Artem Orynko on 5/14/17.
//  Copyright © 2017 GoTo Inc. All rights reserved.
//

import UIKit
import SafariServices

class SplashViewController: UIViewController {

  let gShotButton: UIButton = {
    let image = UIImage(imageLiteralResourceName: "greenShot")
    let button = UIButton(type: .system)
    button.setBackgroundImage(image, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(handleOpenGShot), for: .touchUpInside)

    return button
  }()

  let gShotLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Green Shot"
    label.font = .boldSystemFont(ofSize: 16)
    label.textColor = secondColor
    label.textAlignment = .center

    return label
  }()

  let invitationButton: UIButton = {
    let image = UIImage(imageLiteralResourceName: "invitations")
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setBackgroundImage(image, for: .normal)
    button.addTarget(self, action: #selector(handleOpenInvitation), for: .touchUpInside)

    return button
  }()

  let invitationLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = NSLocalizedString("invitation", comment: "")
    label.textColor = secondColor
    label.font = .boldSystemFont(ofSize: 16)
    label.textAlignment = .center

    return label
  }()

  let searchButton: UIButton = {
    let image = UIImage(imageLiteralResourceName: "search")
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setBackgroundImage(image, for: .normal)
    button.addTarget(self, action: #selector(handleOpenSearch), for: .touchUpInside)

    return button
  }()

  let searchLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = NSLocalizedString("search", comment: "")
    label.textColor = secondColor
    label.font = .boldSystemFont(ofSize: 16)
    label.textAlignment = .center

    return label
  }()

  let myCardButton: UIButton = {
    let image = UIImage(imageLiteralResourceName: "star")
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setBackgroundImage(image, for: .normal)
    button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)

    return button
  }()

  let myCardLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = NSLocalizedString("myCard", comment: "")
    label.textColor = secondColor
    label.font = .boldSystemFont(ofSize: 16)
    label.textAlignment = .center

    return label
  }()

  let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Green Shot"
    label.font = .boldSystemFont(ofSize: 56)
    label.textColor = secondColor
    label.textAlignment = .center

    return label
  }()

  let supportButton: UIButton = {
    let image = UIImage(imageLiteralResourceName: "support")
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setBackgroundImage(image, for: .normal)
    button.addTarget(self, action: #selector(handleOpenSupport), for: .touchUpInside)

    return button
  }()

  let supportLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = NSLocalizedString("support", comment: "")
    label.textColor = secondColor
    label.font = .boldSystemFont(ofSize: 16)
    label.textAlignment = .center

    return label
  }()

  let newCardButton: UIButton = {
    let image = UIImage(imageLiteralResourceName: "newCard")
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setBackgroundImage(image, for: .normal)
    button.addTarget(self, action: #selector(handleNewCard), for: .touchUpInside)

    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupViews()
  }

  func handleOpenGShot() {
    checkIfUserIsLoggedIn()
  }

  func handleOpenInvitation() {
    if let url = URL(string: "http://www.greenbook.co.il/?app=mb") {
      open(url: url)
    }
  }

  func handleOpenSearch(){
    if let url = URL(string: "http://greenbook.co.il/?app=card_search") {
      open(url: url)
    }
  }

  func handleLogin() {
    let userDefault = UserDefaults.standard
    if !userDefault.bool(forKey: "login") {
      let loginVC = LoginViewController()
      present(loginVC, animated: true)
    } else {
      let keychainWrapper = KeychainWrapper()
      let firstValue = keychainWrapper.find(itemKey: "login")!
      let secondValue = keychainWrapper.find(itemKey: "pass")!

      let urlString = "http://www.greenbook.co.il/card/\(firstValue)/\(secondValue)"
      if let url = URL(string: urlString) {
        open(url: url)
      }
    }
  }

  func handleOpenSupport() {
    if let url = URL(string: "http://greenbook.co.il/?app=sprt&ln=he") {
      open(url: url)
    }
  }

  func handleNewCard() {
    if let url = URL(string: "http://req.greenbook.co.il/lp/100") {
      open(url: url)
    }
  }

  func open(url: URL) {
    let safariVC = SFSafariViewController(url: url, entersReaderIfAvailable: false)

    if #available(iOS 10.0, *) {
      safariVC.preferredBarTintColor = secondColor
    } else {
      // Fallback on earlier versions
    }
    present(safariVC, animated: true)
  }

  func checkIfUserIsLoggedIn() {
    let userDefaults = UserDefaults.standard
    if !userDefaults.bool(forKey: "login") {
      login()
    } else {
      let recordVC = RecordViewController()
      present(recordVC, animated: true)
    }
  }

  func login() {
    let recordVC = RecordViewController()
    present(recordVC, animated: true)
  }

  func setupViews() {
    view.backgroundColor = .white

    view.addSubview(gShotButton)
    view.addSubview(gShotLabel)

    view.addSubview(invitationButton)
    view.addSubview(invitationLabel)

    view.addSubview(searchLabel)
    view.addSubview(searchButton)

    view.addSubview(myCardLabel)
    view.addSubview(myCardButton)

    view.addSubview(titleLabel)

    view.addSubview(supportButton)
    view.addSubview(supportLabel)

    view.addSubview(newCardButton)

    gShotButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    gShotButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -70).isActive = true
    gShotButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
    gShotButton.widthAnchor.constraint(equalToConstant: 80).isActive = true

    gShotLabel.topAnchor.constraint(equalTo: gShotButton.bottomAnchor, constant: 10).isActive = true
    gShotLabel.centerXAnchor.constraint(equalTo: gShotButton.centerXAnchor).isActive = true

    invitationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    invitationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 70).isActive = true
    invitationButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
    invitationButton.widthAnchor.constraint(equalToConstant: 80).isActive = true

    invitationLabel.topAnchor.constraint(equalTo: invitationButton.bottomAnchor, constant: 10).isActive = true
    invitationLabel.centerXAnchor.constraint(equalTo: invitationButton.centerXAnchor).isActive = true

    searchLabel.bottomAnchor.constraint(equalTo: gShotButton.topAnchor, constant: -20).isActive = true
    searchLabel.centerXAnchor.constraint(equalTo: gShotButton.centerXAnchor).isActive = true

    searchButton.bottomAnchor.constraint(equalTo: searchLabel.topAnchor, constant: -10).isActive = true
    searchButton.centerXAnchor.constraint(equalTo: searchLabel.centerXAnchor).isActive = true
    searchButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
    searchButton.widthAnchor.constraint(equalToConstant: 80).isActive = true

    myCardLabel.bottomAnchor.constraint(equalTo: invitationButton.topAnchor, constant: -20).isActive = true
    myCardLabel.centerXAnchor.constraint(equalTo: invitationButton.centerXAnchor).isActive = true

    myCardButton.bottomAnchor.constraint(equalTo: myCardLabel.topAnchor, constant: -10).isActive = true
    myCardButton.centerXAnchor.constraint(equalTo: myCardLabel.centerXAnchor).isActive = true
    myCardButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
    myCardButton.widthAnchor.constraint(equalToConstant: 80).isActive = true

    titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: myCardButton.topAnchor, constant: -20).isActive = true

    supportButton.topAnchor.constraint(equalTo: invitationLabel.bottomAnchor, constant: 20).isActive = true
    supportButton.centerXAnchor.constraint(equalTo: invitationLabel.centerXAnchor).isActive = true
    supportButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
    supportButton.widthAnchor.constraint(equalToConstant: 80).isActive = true

    supportLabel.topAnchor.constraint(equalTo: supportButton.bottomAnchor, constant: 10).isActive = true
    supportLabel.centerXAnchor.constraint(equalTo: supportButton.centerXAnchor).isActive = true

    newCardButton.topAnchor.constraint(equalTo: supportLabel.bottomAnchor, constant: 20).isActive = true
    newCardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    newCardButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
  }

}

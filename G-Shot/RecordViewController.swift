//
// Created by alexey on 5/5/17.
// Copyright (c) 2017 GoTo Inc. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {

    let surfaceView: UIImageView = {
        let image = UIImage(imageLiteralResourceName: "surface_bg")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    let cameraVideoImage: UIImageView = {
        let image = UIImage(imageLiteralResourceName: "video_off")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    let cameraPhotoImage: UIImageView = {
        let image = UIImage(imageLiteralResourceName: "camera_on")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    let selectorButton: UIButton = {
        let image = UIImage(imageLiteralResourceName: "selector_photo")
        let button = UIButton(type: .system)
        button.setBackgroundImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    let switchCameraButton: UIButton = {
        let image = UIImage(imageLiteralResourceName: "change_camera_front")
        let button = UIButton(type: .system)
        button.setBackgroundImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    let galleryButton: UIButton = {
        let image = UIImage(imageLiteralResourceName: "gallery_shortcut")
        let imageSelected = UIImage(imageLiteralResourceName: "gallery_pressed")
        let button = UIButton(type: .system)
        button.setBackgroundImage(image, for: .normal)
        button.setBackgroundImage(imageSelected, for: .selected)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    let updateWatermarksButton: UIButton = {
        let image = UIImage(imageLiteralResourceName: "update_watermarks")
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(image, for: .normal)

        return button
    }()

    let recordButton: UIButton = {
        let image = UIImage(imageLiteralResourceName: "cameraoff")
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(image, for: .normal)

        return button
    }()

    let prevWatermarkButton: UIButton = {
        let image = UIImage(imageLiteralResourceName: "prev_button")
        let imageSelected = UIImage(imageLiteralResourceName: "prev_button_selected")
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(image, for: .normal)
        button.setBackgroundImage(imageSelected, for: .selected)

        return button
    }()

    let nextWatermarkButton: UIButton = {
        let image = UIImage(imageLiteralResourceName: "next_button")
        let imageSelected = UIImage(imageLiteralResourceName: "next_button_selected")
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(image, for: .normal)
        button.setBackgroundImage(imageSelected, for: .selected)

        return button
    }()

    lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("X", for: .normal)
        button.tintColor = .lightGray
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        checkIfUserIsLoggedIn()
    }

    private func setupViews() {

        view.backgroundColor = mainColor

        view.addSubview(surfaceView)

        view.addSubview(cameraVideoImage)
        view.addSubview(cameraPhotoImage)
        view.addSubview(selectorButton)
        view.addSubview(switchCameraButton)
        view.addSubview(galleryButton)
        view.addSubview(updateWatermarksButton)
        view.addSubview(recordButton)
        view.addSubview(prevWatermarkButton)
        view.addSubview(nextWatermarkButton)
        view.addSubview(logoutButton)

        surfaceView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        surfaceView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        surfaceView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        surfaceView.heightAnchor.constraint(equalTo: surfaceView.widthAnchor).isActive = true


        cameraVideoImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        cameraVideoImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.width * 0.02).isActive = true
        cameraVideoImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cameraVideoImage.widthAnchor.constraint(equalToConstant: 30).isActive = true

        cameraPhotoImage.bottomAnchor.constraint(equalTo: cameraVideoImage.bottomAnchor).isActive = true
        cameraPhotoImage.leftAnchor.constraint(equalTo: cameraVideoImage.rightAnchor, constant: 10).isActive = true
        cameraPhotoImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        cameraPhotoImage.widthAnchor.constraint(equalToConstant: 30).isActive = true

        selectorButton.bottomAnchor.constraint(equalTo: cameraVideoImage.topAnchor, constant: -5).isActive = true
        selectorButton.leftAnchor.constraint(equalTo: cameraVideoImage.leftAnchor).isActive = true
        selectorButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.24).isActive = true
        selectorButton.heightAnchor.constraint(equalToConstant: 55).isActive = true

        switchCameraButton.bottomAnchor.constraint(equalTo: selectorButton.bottomAnchor).isActive = true
        switchCameraButton.leftAnchor.constraint(equalTo: selectorButton.rightAnchor, constant: 0).isActive = true
        switchCameraButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.24).isActive = true
        switchCameraButton.heightAnchor.constraint(equalToConstant: 55).isActive = true

        galleryButton.bottomAnchor.constraint(equalTo: selectorButton.bottomAnchor).isActive = true
        galleryButton.leftAnchor.constraint(equalTo: switchCameraButton.rightAnchor).isActive = true
        galleryButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.24).isActive = true
        galleryButton.heightAnchor.constraint(equalToConstant: 55).isActive = true

        updateWatermarksButton.bottomAnchor.constraint(equalTo: selectorButton.bottomAnchor).isActive = true
        updateWatermarksButton.leftAnchor.constraint(equalTo: galleryButton.rightAnchor).isActive = true
        updateWatermarksButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.24).isActive = true
        updateWatermarksButton.heightAnchor.constraint(equalToConstant: 55).isActive = true

        recordButton.topAnchor.constraint(equalTo: surfaceView.bottomAnchor).isActive = true
        recordButton.bottomAnchor.constraint(equalTo: selectorButton.topAnchor).isActive = true
        recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        prevWatermarkButton.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor).isActive = true
        prevWatermarkButton.rightAnchor.constraint(equalTo: recordButton.leftAnchor).isActive = true
        prevWatermarkButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        prevWatermarkButton.widthAnchor.constraint(equalToConstant: 55).isActive = true

        nextWatermarkButton.centerYAnchor.constraint(equalTo: recordButton.centerYAnchor).isActive = true
        nextWatermarkButton.leftAnchor.constraint(equalTo: recordButton.rightAnchor).isActive = true
        nextWatermarkButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        nextWatermarkButton.widthAnchor.constraint(equalToConstant: 55).isActive = true

        logoutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        logoutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }

    func checkIfUserIsLoggedIn() {
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: "login") {
            logout()
        }
    }
    func logout() {
        let loginViewController = LoginViewController()
        self.present(loginViewController, animated: true) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(false, forKey: "login")
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

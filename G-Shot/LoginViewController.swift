//
// Created by alexey on 5/5/17.
// Copyright (c) 2017 GoTo Inc. All rights reserved.
//

import UIKit
import KRProgressHUD

class LoginViewController: UIViewController {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "GreenShot"
        label.font = .boldSystemFont(ofSize: 56)
        label.textColor = secondColor
        label.textAlignment = .center

        return label
    }()

    lazy var loginButton: UIButton = {
        let image = UIImage(imageLiteralResourceName: "start")
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(image, for: .normal)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)

        return button
    }()

    lazy var passwordTextField: LeftRightPaddedTextField = {
        let image = UIImage(imageLiteralResourceName: "bg_input")
        let textField = LeftRightPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.background = image
        textField.contentMode = .scaleAspectFit
        textField.textColor = .white
        textField.textAlignment = .center
        textField.isSecureTextEntry = true
        textField.keyboardType = .numbersAndPunctuation
        textField.returnKeyType = .go
        textField.delegate = self

        return textField
    }()

    let passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red:0.42, green:0.42, blue:0.42, alpha:1.00)
        label.textAlignment = .center
        label.text = NSLocalizedString("password", comment: "Password")
        label.font = .systemFont(ofSize: 24)

        return label
    }()

    lazy var loginTextField: LeftRightPaddedTextField = {
        let image = UIImage(imageLiteralResourceName: "bg_input")
        let textField = LeftRightPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.background = image
        textField.contentMode = .scaleToFill
        textField.textColor = .white
        textField.textAlignment = .center
        textField.keyboardType = .numbersAndPunctuation
        textField.returnKeyType = .next
        textField.delegate = self

        return textField
    }()

    let loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red:0.42, green:0.42, blue:0.42, alpha:1.00)
        label.textAlignment = .center
        label.text = NSLocalizedString("username", comment: "User Name")
        label.font = .systemFont(ofSize: 24)

        return label
    }()

    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            self.loginLabel,
            self.loginTextField,
            self.passwordLabel,
            self.passwordTextField
        ])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 5

        return stack
    }()

    var stackViewConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        observeKeyboardNotifications()
    }

    private func setupViews() {
        view.backgroundColor = mainColor

        view.addSubview(stackView)

        stackViewConstraint = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        stackViewConstraint?.isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true

        loginTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true

        passwordTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true

        view.addSubview(titleLabel)

        titleLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -50).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        view.addSubview(loginButton)

        loginButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 80).isActive = true

    }

    private func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    func keyboardShow(_ notification: NSNotification) {
        let userInfo = notification.userInfo
        guard let keyboardFrame = (userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let loginButtonY = loginButton.frame.origin.y

        if loginButtonY > keyboardFrame.origin.y {
            let offsetY = loginButtonY - keyboardFrame.origin.y + 90
            let duration = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval
            let curve = UIViewAnimationOptions(rawValue: (userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UInt)!)

            stackViewConstraint?.constant = -offsetY
            UIView.animate(
                withDuration: duration!,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 1,
                options: curve,
                animations: {
                    self.view.layoutIfNeeded()
            })
        }

    }
    func keyboardHide(_ notification: NSNotification) {
        let userInfo = notification.userInfo
        let duration = userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval
        let curve = UIViewAnimationOptions(rawValue: (userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UInt)!)

        stackViewConstraint?.constant = 0
        UIView.animate(
                withDuration: duration!,
                delay: 0,
                usingSpringWithDamping: 1,
                initialSpringVelocity: 1,
                options: curve,
                animations: {
                    self.view.layoutIfNeeded()
                })
    }

    func login() {
        KRProgressHUD.set(style: .black)
        KRProgressHUD.show(message: "Loading")
        if let login = loginTextField.text, let password = passwordTextField.text {
            NetworkLayer.login(user: login, password: password) { success in
                if !success {
                    DispatchQueue.main.async {
                        let errorString = NSLocalizedString("error", comment: "")
                        KRProgressHUD.showError(progressHUDStyle: nil, maskType: nil, font: nil, message: errorString)
                    }
                } else {
                    DispatchQueue.main.async {
                        KRProgressHUD.dismiss()
                    }
                    self.saveUserData(login: login, password: password)
                }
             }
        }
    }

    fileprivate func saveUserData(login: String, password: String) {
        let keychainWrapper = KeychainWrapper()
        if keychainWrapper.add(itemKey: "login", itemValue: login) &&
                   keychainWrapper.add(itemKey: "pass", itemValue: password) {
            let userDefaults = UserDefaults.standard
            userDefaults.set(true, forKey: "login")
            dismiss(animated: true)
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }

}

extension LoginViewController: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
            return true
        } else {
            view.endEditing(true)
            login()
            return true
        }
    }

}

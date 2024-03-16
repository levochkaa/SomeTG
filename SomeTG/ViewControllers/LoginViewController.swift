// LoginViewController.swift

import UIKit

class LoginViewController: BaseViewController {
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "phone"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let codeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "code"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "2fa"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .alphabet
        textField.textContentType = .password
        return textField
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.layer.cornerRadius = 20
        button.backgroundColor = .blue
        button.tintColor = .white
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        continueButton.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
    }
    
    @objc func continueButtonPressed() {
        Task.main { try await self._continueButtonPressed() }
    }
    
    func _continueButtonPressed() async throws {
        switch try await td.getAuthorizationState() {
            case .authorizationStateWaitPhoneNumber:
                try await td.setAuthenticationPhoneNumber(phoneNumber: phoneTextField.text, settings: nil)
            case .authorizationStateWaitCode:
                try await td.checkAuthenticationCode(code: codeTextField.text)
            case .authorizationStateWaitPassword:
                try await td.checkAuthenticationPassword(password: passwordTextField.text)
            default:
                break
        }
    }
    
    func setupViews() {
        view.addSubview(phoneTextField)
        view.addSubview(codeTextField)
        view.addSubview(passwordTextField)
        view.addSubview(continueButton)
        
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        codeTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            phoneTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            phoneTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneTextField.widthAnchor.constraint(equalToConstant: 200),
            phoneTextField.heightAnchor.constraint(equalToConstant: 40),
            
            codeTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 20),
            codeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            codeTextField.widthAnchor.constraint(equalToConstant: 200),
            codeTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: 200),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            continueButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.widthAnchor.constraint(equalToConstant: 200),
            continueButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

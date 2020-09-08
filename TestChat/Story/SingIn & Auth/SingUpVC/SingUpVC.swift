//
//  SingUpVC.swift
//  TestChat
//
//  Created by Матвей Чернышев on 07.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit
import FirebaseAuth

final class SingUpVC: BaseVC {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
	}
	
	weak var delegate: AuthNavigatingProtocol?
	
	private lazy var welcomeLabel = UILabel(text: "Good to see you!", font: .avenir26())
	private lazy var emailLabel = UILabel(text: "Email")
	private lazy var passwordLabel = UILabel(text: "Password")
	private lazy var confirmLabel = UILabel(text: "Confirm password")
	private lazy var alreadyLabel = UILabel(text: "Already onbooard?")
	
	private lazy var emailTextField = OneLineTextField(font: .avenir20())
	private lazy var passwordTextField = OneLineTextField(font: .avenir20())
	private lazy var confirmTextField = OneLineTextField(font: .avenir20())
	
	private lazy var signUpButton = UIButton(
		title: "Sing up", titleColor: .white, backgroundColor: .buttonDark(), isShadow: true
	)
	private lazy var loginButton = UIButton(type: .system)
}


private extension SingUpVC {
	
	@objc func signUpButtonTapped() {
		
		AuthService.shared.registre(
			email: emailTextField.text,
			password: passwordTextField.text,
			comfirmPassword: confirmTextField.text) { result in
				
				switch result {
				case .success(let user):
					self.showAlert(message: " You are registered!", title: "Success!") {
						self.present(SetupProfileVC(currentUser: user),
									 animated: true, completion: nil)
					}

				case .failure( let error):
					self.showAlert(message: error.localizedDescription, title: "Error!")
				}
		}
	}
	
	@objc func loginButtonTapped() {
		dismiss(animated: true) {
			self.delegate?.toLoginVC()
		}
	}
	
	func setupUI() {
		
		let stackView = UIStackView(
			arranged: [ UIStackView(arranged: [emailLabel, emailTextField]),
						UIStackView(arranged: [passwordLabel, passwordTextField]),
						UIStackView(arranged: [confirmLabel, confirmTextField]),
						signUpButton],
			
			spacing: 40)
		
		let bottomStackView = UIStackView(
			arranged: [alreadyLabel, loginButton],
			axis: .horizontal,
			spacing: 10)
		
		bottomStackView.alignment = .firstBaseline
		
		loginButton.contentHorizontalAlignment = .leading
		loginButton.setTitle("Login", for: .normal)
		loginButton.setTitleColor(.buttonRed(), for: .normal)
		loginButton.titleLabel?.font = .avenir20()
		
		signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
		loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
		
		view.backgroundColor = .white
		
		welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
		stackView.translatesAutoresizingMaskIntoConstraints = false
		bottomStackView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(welcomeLabel)
		view.addSubview(stackView)
		view.addSubview(bottomStackView)
		
		NSLayoutConstraint.activate([
			welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
			welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 120),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
			
			bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 60),
			bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
			
			signUpButton.heightAnchor.constraint(equalToConstant: 60)
		])
	}
}

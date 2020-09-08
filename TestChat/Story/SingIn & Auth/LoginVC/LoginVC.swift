//
//  LoginVC.swift
//  TestChat
//
//  Created by Матвей Чернышев on 07.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit
import GoogleSignIn

final class LoginVC: BaseVC {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
	}
	
	weak var delegate: AuthNavigatingProtocol?
	
	private lazy var welcomeLabel = UILabel(text: "Welcome back!", font: .avenir20())
	private lazy var loginWithLabel = UILabel(text: "Login with")
	private lazy var orLabel = UILabel(text: "or")
	private lazy var emailLabel = UILabel(text: "Email")
	private lazy var passwordLabel = UILabel(text: "Password")
	private lazy var needAnAccountLabel = UILabel(text: "Need an account?")
	
	private lazy var googleButton = UIButton(
		title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true
	)
	private lazy var loginButton = UIButton(
		title: "Login", titleColor: .white, backgroundColor: .buttonDark(), isShadow: true
	)
	private lazy var singUpButton = UIButton(type: .system)
	
	private lazy var emailTextField = OneLineTextField(font: .avenir20())
	private lazy var passwordTextField = OneLineTextField(font: .avenir20())
}

private extension LoginVC {
	
	@objc func loginButtonTapped() {
		AuthService.shared.login(
			email: emailTextField.text,
			password: passwordTextField.text) { (result) in
				
				switch result {
				case .success(let user):
					self.showAlert(message:" You're registered!", title: "Success!") {
						FirestoreService.shared.getUserData(user: user) { result in
							
							switch result {
							case .success(let user):
								self.present(MainTBC(currentUser: user), animated: true, completion: nil)
								
							case .failure(_):
								self.present(SetupProfileVC(currentUser: user), animated: true, completion: nil)
							}
						}
					}
				case .failure( let error):
					self.showAlert(message: "Error!", title: error.localizedDescription)
				}
		}
	}
	
	@objc func singInButtonTapped() {
		dismiss(animated: true) {
			self.delegate?.toSingUpVC()
		}
	}
	
	@objc func googleButtonTapped() {
		GIDSignIn.sharedInstance()?.presentingViewController = self
		GIDSignIn.sharedInstance().signIn()
	}
	
	func setupUI(){
		loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
		singUpButton.addTarget(self, action: #selector(singInButtonTapped), for: .touchUpInside)
		googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
		
		let googleLogo = UIImageView(image: #imageLiteral(resourceName: "googleLogo"), contentMode: .scaleAspectFit)
		let loginWithView = ButtonFromView(label: loginWithLabel, button: googleButton)
		let emailStackView = UIStackView(arranged: [emailLabel, emailTextField])
		let passwordStackView = UIStackView(arranged: [passwordLabel, passwordTextField])
		
		let stackView = UIStackView(
			arranged: [loginWithView,
					   orLabel,
					   emailStackView,
					   passwordStackView,
					   loginButton],
			spacing: 35)
		
		let bottomStackView = UIStackView(
			arranged: [needAnAccountLabel, singUpButton],
			axis: .horizontal,
			spacing: 10
		)
		
		view.backgroundColor = .white
		
		singUpButton.contentHorizontalAlignment = .leading
		singUpButton.setTitle("Sing UP", for: .normal)
		singUpButton.setTitleColor(.buttonRed(), for: .normal)
		singUpButton.titleLabel?.font = .avenir20()
		
		bottomStackView.alignment = .firstBaseline
		
		googleLogo.translatesAutoresizingMaskIntoConstraints = false
		welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
		stackView.translatesAutoresizingMaskIntoConstraints = false
		bottomStackView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(welcomeLabel)
		view.addSubview(stackView)
		view.addSubview(bottomStackView)
		googleButton.addSubview(googleLogo)
		
		NSLayoutConstraint.activate([
			loginButton.heightAnchor.constraint(equalToConstant: 60),
			
			welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
			welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			stackView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 80),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
			
			bottomStackView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
			bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
			
			googleLogo.leadingAnchor.constraint(equalTo: googleButton.leadingAnchor, constant: 24),
			googleLogo.centerYAnchor.constraint(equalTo: googleButton.centerYAnchor)
		])
	}
	
}

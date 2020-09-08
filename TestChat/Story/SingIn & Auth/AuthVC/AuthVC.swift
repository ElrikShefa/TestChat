//
//  AuthVC.swift
//  TestChat
//
//  Created by Матвей Чернышев on 06.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit
import GoogleSignIn

final class AuthVC: BaseVC {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
	}
	private lazy var logoImageView = UIImageView(image: #imageLiteral(resourceName: "Logo"), contentMode: .scaleAspectFit)
	
	private lazy var googleLabel = UILabel(text: "Cet started with")
	private lazy var emailLabel = UILabel(text: "Or sing up with")
	private lazy var alredyOnBoardLabel = UILabel(text: "Already onboard?")
	
	private lazy var googleButton = UIButton(
		title: "Google", titleColor: .black, backgroundColor: .white, isShadow: true
	)
	private lazy var emailButton = UIButton(
		title: "Email", titleColor: .white, backgroundColor: .buttonDark(), isShadow: true
	)
	private lazy var loginButton = UIButton(
		title: "Login", titleColor: .buttonRed(), backgroundColor: .white, isShadow: true
	)
}

private extension AuthVC {
	
	@objc func emailButtonTapped() {
		present(SingUpVC(), animated: true, completion: nil)
	}
	
	@objc func loginButtonTapped() {
		present(LoginVC(), animated: true, completion: nil)
	}
	
	@objc func googleButtonTapped() {
		GIDSignIn.sharedInstance()?.presentingViewController = self
		GIDSignIn.sharedInstance().signIn()
	}
	
	func setupUI() {
		let loginVC = LoginVC()
		loginVC.delegate = self
		
		let singUpVC = SingUpVC()
		singUpVC.delegate = self
		
		GIDSignIn.sharedInstance()?.delegate = self
	
		let googleLogo = UIImageView(image: #imageLiteral(resourceName: "googleLogo"), contentMode: .scaleAspectFit)
		let googleView = ButtonFromView(label: googleLabel, button: googleButton)
		let emailView = ButtonFromView(label: emailLabel, button: emailButton)
		let alredyOnBoardView = ButtonFromView(label: alredyOnBoardLabel, button: loginButton)
		
		emailButton.addTarget(self, action: #selector(emailButtonTapped), for: .touchUpInside)
		loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
		googleButton.addTarget(self, action: #selector(googleButtonTapped), for: .touchUpInside)
		
		let stackView = UIStackView(
			arranged: [googleView, emailView, alredyOnBoardView], spacing: 40
		)
		
		logoImageView.translatesAutoresizingMaskIntoConstraints = false
		stackView.translatesAutoresizingMaskIntoConstraints = false
		googleLogo.translatesAutoresizingMaskIntoConstraints = false

		view.backgroundColor = .white
		
		view.addSubview(logoImageView)
		view.addSubview(stackView)
		googleButton.addSubview(googleLogo)

		NSLayoutConstraint.activate([
			logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 140),
			logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
			
			googleLogo.leadingAnchor.constraint(equalTo: googleButton.leadingAnchor, constant: 24),
			googleLogo.centerYAnchor.constraint(equalTo: googleButton.centerYAnchor)
		])
	}
}

extension AuthVC: GIDSignInDelegate {
	func sign(
		_ signIn: GIDSignIn!,
		didSignInFor user: GIDGoogleUser!,
		withError error: Error!
	) {
		AuthService.shared.googleLogin(user: user, error: error) { result in
			guard let topVC = UIApplication.getTopViewController() as? BaseVC else { return }
			
			switch result {
			case .success(let user):
				FirestoreService.shared.getUserData(user: user) { result in
					
					switch result {
					case .success(let mUser):
							topVC.showAlert(message: "You're authorized", title: "Success!") {
							topVC.present(MainTBC(currentUser: mUser), animated: true, completion: nil)
						}
						
					case .failure(_):
						topVC.showAlert(message: "You're register", title: "Success!") {
							topVC.present(SetupProfileVC(currentUser: user), animated: true, completion: nil)
						}
					}
				}
				
			case .failure(let error):
				self.showAlert(message: error.localizedDescription, title: "Mistake")
			}
		}
	}
}

extension AuthVC: AuthNavigatingProtocol {
	
	func toLoginVC() {
		present(LoginVC(), animated: true, completion: nil)
	}
	
	func toSingUpVC() {
		present(SingUpVC(), animated: true, completion: nil)
	}
}

//
//  AuthService.swift
//  TestChat
//
//  Created by Матвей Чернышев on 18.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

struct AuthService {
	
	static let shared = AuthService()
	let auth = Auth.auth()
}

extension AuthService {
	
	 func login (
		email: String?,
		password: String?,
		completion: @escaping (Result<User, Error>) -> Void) {
		
		guard
			let email = email,
			let password = password else {
				completion(.failure(AuthError.notFilled))
				return
		}
		
		auth.signIn(withEmail: email, password: password) { (result, error) in
			
			guard let result = result else {
				completion(.failure(error!))
				return
			}
			
			completion(.success(result.user))
		}
	}
	
	func registre(
		email: String?,
		password: String?,
		comfirmPassword: String?,
		completion: @escaping (Result<User, Error>) -> Void) {
		
		guard Validators.isFilled(
			email: email,
			password: password,
			comfirmPassword: comfirmPassword
			) else {
				completion(.failure(AuthError.notFilled))
				return
		}
		
		guard password!.lowercased() == comfirmPassword!.lowercased() else {
			completion(.failure(AuthError.passwordNotMatches))
			return
		}
		
		guard Validators.isSimpleEmail(email!) else {
			completion(.failure(AuthError.invalidEmail))
			return
		}
		
		auth.createUser(withEmail: email!, password: password!) { (result, error) in
			
			guard let result = result else {
				completion(.failure(error!))
				return
			}
			
			completion(.success(result.user))
		}
	}
	
	func googleLogin(
		user: GIDGoogleUser!,
		error: Error!,
		completion: @escaping (Result<User, Error>) -> Void
	) {
		if let error = error {
			completion(.failure(error))
			return
		}
		
		guard let auth = user.authentication else { return }
		
		let credential  = GoogleAuthProvider.credential(
			withIDToken: auth.idToken,
			accessToken: auth.accessToken
		)
		Auth.auth().signIn(with: credential) { (result, error) in
			guard let result = result else {
				completion(.failure(error!))
				return
			}
			completion(.success(result.user))
		}
	}
}


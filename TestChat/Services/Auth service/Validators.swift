//
//  Validators.swift
//  TestChat
//
//  Created by Матвей Чернышев on 18.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import Foundation

enum Validators {}

extension Validators {
	
	static func isFilled(email: String?,
						 password: String?,
						 comfirmPassword: String?) -> Bool {
		
		guard
			let password = password,
			let comfirmPassword = comfirmPassword,
			let email = email,
			password != "",
			comfirmPassword != "",
			email != "" else {
				return false
		}
		return true
	}
	
	static func isFilled(username: String?,
						 description: String?,
						 sex: String?) -> Bool {
		
		guard
			let username = username,
			let description = description,
			let sex = sex,
			username != "",
			description != "",
			sex != "" else {
				return false
		}
		return true
	}
	
	static func isSimpleEmail(_ email: String) -> Bool {
		let emailRedEx = "^.+@.+\\..{2,}$"
		return check(text: email, redEx: emailRedEx)
	}
	
	private static func check(text: String, redEx: String) -> Bool {
		let predicate = NSPredicate(format: "SELF MATCHES %@", redEx)
		return predicate.evaluate(with: text)
	}
}

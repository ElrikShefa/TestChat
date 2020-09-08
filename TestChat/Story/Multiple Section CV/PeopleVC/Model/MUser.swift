//
//  MUser.swift
//  TestChat
//
//  Created by Матвей Чернышев on 15.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit
import FirebaseFirestore

struct MUser: Hashable, Decodable {
	
	init(
		username: String,
		email: String,
		avatarStringURL: String,
		description: String,
		sex: String,
		id: String
	) {
		self.username = username
		self.email = email
		self.avatarStringURL = avatarStringURL
		self.description = description
		self.sex = sex
		self.id = id
	}
	
	init?(document: DocumentSnapshot) {
		guard
			let data = document.data(),
			let username = data["username"] as? String,
			let email = data["email"] as? String,
			let avatarStringURL = data["avatarStringURL"] as? String,
			let description = data["description"] as? String,
			let sex = data["sex"] as? String,
			let id = data["uid"] as? String else { return nil }
		
		self.username = username
		self.email = email
		self.avatarStringURL = avatarStringURL
		self.description = description
		self.sex = sex
		self.id = id
	}
	
	init?(document: QueryDocumentSnapshot) {
		
		let data = document.data()
		
		guard
			let username = data["username"] as? String,
			let email = data["email"] as? String,
			let avatarStringURL = data["avatarStringURL"] as? String,
			let description = data["description"] as? String,
			let sex = data["sex"] as? String,
			let id = data["uid"] as? String else { return nil }
		
		self.username = username
		self.email = email
		self.avatarStringURL = avatarStringURL
		self.description = description
		self.sex = sex
		self.id = id
	}
	
	var username: String
	var email: String
	var avatarStringURL: String
	var description: String
	var sex: String
	var id: String
	
	var representation: [String: Any] {
		var rep = ["username": username]
		rep["email"] = username
		rep["avatarStringURL"] = avatarStringURL
		rep["description"] = description
		rep["sex"] = sex
		rep["uid"] = id
		
		return rep
	}
}

extension MUser {
	
	func hash(info hasher: inout Hasher) {
		hasher.combine(id)
	}
	
	static func  == (lhs: MUser, rhs: MUser) -> Bool {
		return lhs.id == rhs.id
	}
	
	func contains(filter: String?) -> Bool {
		
		guard let filter = filter else { return true }
		if filter.isEmpty { return true }
		let lowercasedFilter = filter.lowercased()
		
		return username.lowercased().contains(lowercasedFilter)	
	}
}

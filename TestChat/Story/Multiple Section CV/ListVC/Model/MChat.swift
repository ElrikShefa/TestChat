//
//  MChat.swift
//  TestChat
//
//  Created by Матвей Чернышев on 13.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct MChat: Hashable, Decodable {
	
	init(
		friendUserName: String,
		friendAvatarStringURl: String,
		lastMessageContent: String,
		friendId: String
	) {
		self.friendUserName = friendUserName
		self.friendAvatarStringURl = friendAvatarStringURl
		self.lastMessageContent = lastMessageContent
		self.friendId = friendId
	}
	
	init?(document: QueryDocumentSnapshot) {
		let data = document.data()
		
		guard
			let friendUserName = data["friendUserName"] as? String,
			let friendAvatarStringURl = data["friendAvatarStringURl"] as? String,
			let lastMessageContent = data["lastMessage"] as? String,
			let friendId = data["friendId"] as? String else { return nil }
		
		self.friendUserName = friendUserName
		self.friendAvatarStringURl = friendAvatarStringURl
		self.lastMessageContent = lastMessageContent
		self.friendId = friendId
	}

	var friendUserName: String
	var friendAvatarStringURl: String
	var lastMessageContent: String
	var friendId: String
	
	var representation: [String: Any] {
		var rep = ["friendUserName": friendUserName]
		rep["friendAvatarStringURl"] = friendAvatarStringURl
		rep["friendId"] = friendId
		rep["lastMessage"] = lastMessageContent
		return rep
	}
}

extension MChat {
	
	func hash(info hasher: inout Hasher) {
		hasher.combine(friendId)
	}
	
	static func  == (lhs: MChat, rhs: MChat) -> Bool {
		return lhs.friendId == rhs.friendId
	}
}

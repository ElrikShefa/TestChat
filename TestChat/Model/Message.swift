//
//  Message.swift
//  TestChat
//
//  Created by Матвей Чернышев on 26.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import Foundation
import FirebaseFirestore
import MessageKit

struct Message: Hashable, MessageType {
	
	let content: String
	let sentDate: Date
	let id: String?
	
	var image: UIImage? = nil
	var downloadURL: URL? = nil
	
	var sender: SenderType
	var kind: MessageKind {
		//		return .text(content)
		
		if let image = image {
			let mediaItem = ImageItem(url: nil, image: nil, placeholderImage: image, size: image.size)
			return .photo(mediaItem)
		} else {
			return .text(content)
		}
	}
	var messageId: String {
		return id ?? UUID().uuidString
	}
	
	init(user: MUser, content: String) {
		self.content = content
		sender = Sender(senderId: user.id, displayName: user.avatarStringURL)
		sentDate = Date()
		id = nil
	}
	
	init(user: MUser, image: UIImage) {
		self.content = ""
		sender = Sender(senderId: user.id, displayName: user.avatarStringURL)
		self.image = image
		sentDate = Date()
		id = nil
	}
	
	init?(document: QueryDocumentSnapshot) {
		let data = document.data()
		
		guard
			let date = data["created"] as? Timestamp,
			let senderID = data["senderID"] as? String,
//			let content = data["content"] as? String,
			let senderUserName = data["senderUserName"] as? String else { return nil}
		
		self.id = document.documentID
		self.sentDate = date.dateValue()
		sender = Sender(senderId: senderID, displayName: senderUserName)
		
		if let content = data["content"] as? String {
			self.content = content
			downloadURL = nil
			
		} else if
			let urlString = data["url"] as? String,
			let url = URL(string: urlString) {
			downloadURL = url
			self.content = ""
			
		} else {
			return nil
		}
	}
	
	var representation: [String: Any] {
		var rep: [String: Any] = [
			"created": sentDate,
			"senderID": sender.senderId,
			"senderUserName": sender.displayName,
		]
		
		if let url = downloadURL {
			rep["url"] = url.absoluteString
		} else {
			rep["content"] = content
			
		}
		return rep
	}
	
	func hash(into hasher: inout Hasher) {
		hasher.combine(messageId)
	}
	
	static func == (lhs: Message, rhs: Message) -> Bool {
		return lhs.messageId == rhs.messageId
	}
}

extension Message: Comparable {
	static func < (lhs: Message, rhs: Message) -> Bool {
		return lhs.sentDate < rhs.sentDate
	}
}

//
//  FirestoreService.swift
//  TestChat
//
//  Created by Матвей Чернышев on 19.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import Firebase
import FirebaseFirestore

final class FirestoreService {
	
	static var shared = FirestoreService()
	
	let db = Firestore.firestore()
	
	private var currentUser: MUser!
	private var usersRef: CollectionReference {
		return db.collection("users")
		
	}
	private var waitingChatsRef: CollectionReference {
		return db.collection(["users", currentUser.id, "waitingChats"].joined(separator: "/"))
	}
	private var activeChatsRef: CollectionReference {
		return db.collection(["users", currentUser.id, "activeChats"].joined(separator: "/"))
	}
}

extension FirestoreService {
	
	func saveProfileWith(
		id: String,
		email: String,
		username: String?,
		avatarImage: UIImage?,
		description: String?,
		sex: String?,
		complition: @escaping (Result<MUser, Error>) -> Void) {
		
		guard Validators.isFilled(username: username, description: description, sex: sex) else {
			complition(.failure(UserError.notFilled))
			return
		}
		
		guard avatarImage != UIImage(named: "avatar-4") else {
			complition(.failure(UserError.photoNotExist))
			return
		}
		
		var mUser = MUser(username: username!,
						  email: email,
						  avatarStringURL: "not exist",
						  description: description!,
						  sex: sex!,
						  id: id)
		
		StorageService.shared.uploadPhoto(image: avatarImage!) { result in
			
			switch result {
			case .success(let url):
				mUser.avatarStringURL = url.absoluteString
				self.usersRef.document(mUser.id).setData(mUser.representation) { error in
					
					if let error = error {
						complition(.failure(error))
					} else {
						complition(.success(mUser))
					}
				}
				
			case .failure(let error):
				complition(.failure(error))
			}
		}
		
		self.usersRef.document(mUser.id).setData(mUser.representation) { (error) in
			if let error = error {
				complition(.failure(error))
				
			} else {
				complition(.success(mUser))
			}
		}
	}
	
	func getUserData(user:User, complition: @escaping (Result<MUser, Error>) -> Void) {
		
		let docRef = usersRef.document(user.uid)
		
		docRef.getDocument { (document, error) in
			if let document = document, document.exists {
				
				guard let mUser = MUser(document: document) else {
					complition(.failure(UserError.notDeployMUSer))
					return
				}
				
				self.currentUser = mUser
				complition(.success(mUser))
			} else {
				complition(.failure(UserError.missingInfo))
			}
		}
	}
	
	func createWaitingChat(
		message: String,
		receiver: MUser,
		completion: @escaping (Result<Void, Error>) -> Void
	) {
		let reference = db.collection(["users", receiver.id, "waitingChats"].joined(separator: "/"))
		let messageRef = reference.document(self.currentUser.id).collection("messages")
		
		let message = Message(user: currentUser, content: message)
		let chat = MChat(friendUserName: currentUser.username,
						 friendAvatarStringURl: currentUser.avatarStringURL,
						 lastMessageContent: message.content,
						 friendId: currentUser.id)
		
		reference.document(currentUser.id).setData(chat.representation) { error in
			if let error = error {
				completion(.failure(error))
				return
			}
			messageRef.addDocument(data: message.representation) { error in
				if let error = error {
					completion(.failure(error))
					return
				}
				completion(.success(Void()))
			}
		}
	}
	
	func deleteWaitingChat(
		chat: MChat,
		completion: @escaping (Result<Void, Error>) -> Void
	) {
		waitingChatsRef.document(chat.friendId).delete { error in
			
			if let error = error {
				completion(.failure(error))
				return
			}
			completion(.success(Void()))
			self.deleteMessages(chat: chat, completion: completion)
		}
	}
	
	func changeToActive(
		chat: MChat,
		completion: @escaping (Result<Void, Error>) -> Void
	) {
		getWaitingChatMessages(chat: chat) { result in
			
			switch result {
			case .success(let messages):
				self.deleteWaitingChat(chat: chat) { result in
					
					switch result {
					case .success():
						self.createActiveChat(chat: chat, messages: messages) { result in
							
							switch result {
							case .success():
								completion(.success(Void()))
								
							case .failure(let error):
								completion(.failure(error))
							}
						}
						
					case .failure(let error):
						completion(.failure(error))
					}
				}
				
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	func sentMessages(
		chat: MChat,
		message: Message,
		completion: @escaping (Result<Void, Error>) -> Void
	) {
		let friendRef = usersRef
			.document(chat.friendId)
			.collection("activeChats")
			.document(currentUser.id)
		
		let friendMessageRef = friendRef.collection("messages")
		
		let myMessageRef = usersRef
			.document(currentUser.id)
			.collection("activeChats")
			.document(chat.friendId)
			.collection("messages")
		
		let chatForFriend = MChat(friendUserName: currentUser.username,
								  friendAvatarStringURl: currentUser.avatarStringURL,
								  lastMessageContent: currentUser.id,
								  friendId: message.content)
		
		friendRef.setData(chatForFriend.representation) { error in
			
			if let error = error {
				completion(.failure(error))
				return
			}
			
			friendMessageRef.addDocument(data: message.representation) { error in
				
				if let error = error {
					completion(.failure(error))
					return
				}
				myMessageRef.addDocument(data: message.representation) { error in
					
					if let error = error {
						completion(.failure(error))
						return
					}
				}
				completion(.success(Void()))
			}
		}
	}
}

private extension FirestoreService {
	
	func deleteMessages(
		chat: MChat,
		completion: @escaping (Result<Void, Error>) -> Void
	) {
		let reference = waitingChatsRef.document(chat.friendId).collection("messages")
		
		getWaitingChatMessages(chat: chat) { result in
			
			switch result {
			case .success(let messages):
				for message in messages {
					
					guard let documentID = message.id else { return }
					let messageRef = reference.document(documentID)
					
					messageRef.delete { error in
						if let error = error {
							completion(.failure(error))
							return
						}
						completion(.success(Void()))
					}
				}
				
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	func getWaitingChatMessages(
		chat: MChat,
		completion: @escaping (Result<[Message], Error>) -> Void
	) {
		let reference = waitingChatsRef.document(chat.friendId).collection("messages")
		
		var messages = [Message]()
		
		reference.getDocuments { (querySnapshot, error) in
			if let error = error {
				completion(.failure(error))
				return
			}
			
			guard let documents = querySnapshot?.documents else { return }
			for document in documents {
				guard let message = Message(document: document) else { return }
				messages.append(message)
			}
			completion(.success(messages))
		}
	}
	
	func createActiveChat(
		chat: MChat,
		messages: [Message],
		completion: @escaping (Result<Void, Error>) -> Void
	) {
		let messageRef = activeChatsRef.document(chat.friendId).collection("messages")
		
		activeChatsRef.document(chat.friendId).setData(chat.representation) { error in
			
			if let error = error {
				completion(.failure(error))
				return
			}
			
			for message in messages {
				messageRef.addDocument(data: message.representation) { error in
					
					if let error = error {
						completion(.failure(error))
						return
					}
					completion(.success(Void()))
				}
			}
		}
	}
}

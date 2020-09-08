//
//  ListenerService.swift
//  TestChat
//
//  Created by Матвей Чернышев on 24.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore

final class ListenerService {
	
	static let shared = ListenerService()
	
	private let db = Firestore.firestore()
	
	private var userRef: CollectionReference {
		return db.collection("users")
	}
	
	private var currentUserId: String {
		return Auth.auth().currentUser!.uid
	}
}

extension ListenerService {
	
	func usersObserve(
		users: [MUser],
		comletion: @escaping (Result<[MUser], Error>) -> Void
	) -> ListenerRegistration? {
		
		var users = users
		
		let usersListener = userRef.addSnapshotListener { (querySnapshot, error) in
			guard let snapshot = querySnapshot else {
				comletion(.failure(error!))
				return
			}
			
			snapshot.documentChanges.forEach { diff in
				guard let mUser = MUser(document: diff.document) else { return }
				
				switch diff.type {
				case .added:
					guard
						!users.contains(mUser),
						mUser.id != self.currentUserId else { return }
					users.append(mUser)
					
				case .modified:
					guard let index = users.firstIndex(of: mUser) else { return }
					users[index] = mUser
					
				case .removed:
					guard let index = users.firstIndex(of: mUser) else { return }
					users.remove(at: index)
				}
			}
			comletion(.success(users))
		}
		return usersListener
	}
	//	MARK:- WTF?
	func waitingChatsObserve(
		chats: [MChat],
		comletion: @escaping (Result<[MChat], Error>) -> Void
	) -> ListenerRegistration? {
		var chats = chats
		
		let chatsRef = db.collection(["users", currentUserId, "waitingChats"].joined(separator: "/"))
		let chatsListener = chatsRef.addSnapshotListener { (querySnapshot, error) in
			
			guard let snapshot = querySnapshot else {
				comletion(.failure(error!))
				return
			}
			snapshot.documentChanges.forEach { diff in
				guard let chat = MChat(document: diff.document) else { return }
				
				switch diff.type {
				case .added:
					guard !chats.contains(chat) else { return }
					chats.append(chat)
					
				case .modified:
					guard let index = chats.firstIndex(of: chat) else { return }
					chats[index] = chat
					
				case .removed:
					guard let index = chats.firstIndex(of: chat) else { return }
					chats.remove(at: index)
				}
			}
			comletion(.success(chats))
		}
		return chatsListener
	}
	
	func activeChatsObserve(
		chats: [MChat],
		comletion: @escaping (Result<[MChat], Error>) -> Void
	) -> ListenerRegistration? {
		var chats = chats
		
		let chatsRef = db.collection(["users", currentUserId, "activeChats"].joined(separator: "/"))
		let chatsListener = chatsRef.addSnapshotListener { (querySnapshot, error) in
			
			guard let snapshot = querySnapshot else {
				comletion(.failure(error!))
				return
			}
			snapshot.documentChanges.forEach { diff in
				guard let chat = MChat(document: diff.document) else { return }
				
				switch diff.type {
				case .added:
					guard !chats.contains(chat) else { return }
					chats.append(chat)
					
				case .modified:
					guard let index = chats.firstIndex(of: chat) else { return }
					chats[index] = chat
					
				case .removed:
					guard let index = chats.firstIndex(of: chat) else { return }
					chats.remove(at: index)
				}
			}
			comletion(.success(chats))
		}
		return chatsListener
	}
	
	func messagesObserve(
		chat: MChat,
		comletion: @escaping (Result<Message, Error>) -> Void
	) -> ListenerRegistration? {
		
		let ref = userRef
			.document(currentUserId)
			.collection("activeChats")
			.document(chat.friendId)
			.collection("messages")
		
		let messageListener = ref.addSnapshotListener { (querySnapshot, error) in
			
			guard let snapshot = querySnapshot else {
				comletion(.failure(error!))
				return
			}
			
			snapshot.documentChanges.forEach { diff in
				guard let message = Message(document: diff.document) else { return }
				
				switch diff.type {
				case .added:
					comletion(.success(message))
					
				case .modified:
					break
					
				case .removed:
					break
				}
			}
		}
		return messageListener
	}
}


//
//  StorageService.swift
//  TestChat
//
//  Created by Матвей Чернышев on 23.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

final class StorageService {
	
	static let shared = StorageService()
	
	let storageRef = Storage.storage().reference()
	
	private var avatarsRef: StorageReference {
		return storageRef.child("avatars")
	}
	
	private var currentUserId: String {
		return Auth.auth().currentUser!.uid
	}
}

extension StorageService {
	
	func uploadPhoto(image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
		
		guard
			let scaledImage = image.scaledToSafeUploadSize,
			let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return }
		
		let metaData = StorageMetadata()
		metaData.contentType = "image/jpeg"
		
		avatarsRef.child(currentUserId).putData(imageData, metadata: metaData) { (metaData, error) in
			guard let _ = metaData else {
				guard let error = error else { return }
				completion(.failure(error))
				return
			}
			
			self.avatarsRef.child(self.currentUserId).downloadURL { (url, error) in
				guard let downloadURL = url  else {
					guard let error = error else { return }
					completion(.failure(error))
					return
				}
				completion(.success(downloadURL))
				
			}
		}
	}
	
	func uploadImageMessage(
		photo: UIImage,
		chat: MChat,
		completion: @escaping (Result<URL, Error>) -> Void ) {
		
		guard
			let scaledImage = photo.scaledToSafeUploadSize,
			let imageData = scaledImage.jpegData(compressionQuality: 0.4) else { return }
		
		let metaData = StorageMetadata()
		metaData.contentType = "image/jpeg"
		
		let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
		guard let uid: String = Auth.auth().currentUser?.uid else { return }
		let chatName = [chat.friendUserName, uid].joined()
		
		self.storageRef.child(chatName).child(imageName).putData(imageData, metadata: metaData) { (metaData, error) in
			
			guard let _ = metaData else {
				guard let error = error else { return }
				completion(.failure(error))
				return
			}
			
			self.storageRef.child(chatName).child(imageName).downloadURL { (url, error) in
				guard let downloadURL = url  else {
					guard let error = error else { return }
					completion(.failure(error))
					return
				}
				completion(.success(downloadURL))
			}
		}
	}
	
	func downloadImage(
		url: URL,
		completion: @escaping (Result<UIImage?, Error>) -> Void) {
		
		let ref = Storage.storage().reference(forURL: url.absoluteString)
		let MB = Int64(1 * 1024 * 1024)
		
		ref.getData(maxSize: MB) { (data, error) in
			
			guard let imageData = data else {
				guard let error = error else { return }
				completion(.failure(error))
				return
			}
			completion(.success(UIImage(data: imageData)))
		}
	}
}



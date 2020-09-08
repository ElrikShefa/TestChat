//
//  SceneDelegate.swift
//  TestChat
//
//  Created by Матвей Чернышев on 06.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit
import FirebaseAuth

final class SceneDelegate: UIResponder {
	
	var window: UIWindow?
	
	func scene(_ scene: UIScene,
			   willConnectTo session: UISceneSession,
			   options connectionOptions: UIScene.ConnectionOptions) {
		
		guard let windowScene = (scene as? UIWindowScene) else { return }
		
		window = .init(windowScene: windowScene)
		
		if let user = Auth.auth().currentUser {
			FirestoreService.shared.getUserData(user: user) { result in
				
				switch result {
				case .success(let user):
					self.window?.rootViewController = MainTBC(currentUser: user)
					
				case .failure(_):
					self.window?.rootViewController = AuthVC()
				}
			}
		} else {
			 window?.rootViewController = AuthVC()
		}
		
		window?.makeKeyAndVisible()
	}
}

extension SceneDelegate: UIWindowSceneDelegate {}


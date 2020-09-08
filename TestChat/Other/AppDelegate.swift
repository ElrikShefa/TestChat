//
//  AppDelegate.swift
//  TestChat
//
//  Created by Матвей Чернышев on 06.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FirebaseStorage

@UIApplicationMain
final class AppDelegate: UIResponder {
	
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
	) -> Bool {
		FirebaseApp.configure()
		GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
		return true
	}
	
	@available(iOS 9.0, *)
	func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
	  -> Bool {
	  return GIDSignIn.sharedInstance().handle(url)
	}
}

extension AppDelegate: UIApplicationDelegate {}

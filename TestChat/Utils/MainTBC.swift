//
//  MainTBC.swift
//  TestChat
//
//  Created by Матвей Чернышев on 21.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

final class MainTBC: UITabBarController {
	
	init(currentUser: MUser) {
		self.currentUser = currentUser
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setViewControllers([makePeopleVC(), makelistVC()], animated: true)
		tabBar.tintColor = #colorLiteral(red: 0.5568627451, green: 0.3529411765, blue: 0.968627451, alpha: 1)
		modalPresentationStyle = .fullScreen
	}
	
	private let currentUser: MUser
}

private extension MainTBC {
	
	func makelistVC() -> UIViewController {
		let listVC = ListVC(currentUser: currentUser)
		listVC.tabBarItem = UITabBarItem(
			title: "Conversation",
			image: UIImage(systemIcon: .conversation),
			tag: 0
		)
		
		return UINavigationController(rootViewController: listVC)
	}
	
	func makePeopleVC() -> UIViewController {
		let peopleVC = PeopleVC(currentUser: currentUser)
		peopleVC.tabBarItem =  UITabBarItem(
			title: "People",
			image: UIImage(systemIcon: .person2),
			tag: 0
		)
		
		return UINavigationController(rootViewController: peopleVC)
	}
}

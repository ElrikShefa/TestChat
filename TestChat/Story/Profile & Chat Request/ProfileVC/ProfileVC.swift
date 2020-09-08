//
//  ProfileVC.swift
//  TestChat
//
//  Created by Матвей Чернышев on 17.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit
import SDWebImage

final class ProfileVC: BaseVC {
	
	init(user: MUser) {
		self.user = user
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
	}
	private let user: MUser

	private lazy var nameLabel = UILabel(
		text: user.username,
		font: .systemFont(ofSize: 20, weight: .light)
	)
	private lazy var aboutLabel = UILabel(
		text: user.description,
		font: .systemFont(ofSize: 16, weight: .light)
	)
	private lazy var textField = InsertableTextField()
	private lazy var container = UIView()
	private lazy var imageView = UIImageView()
}

private extension ProfileVC {
	func setupUI() {
		imageView.contentMode = .scaleAspectFill
		imageView.sd_setImage(with: URL(string: user.avatarStringURL), completed: nil)
		
		view.backgroundColor = .magenta
		
		container.layer.cornerRadius = 30
		container.backgroundColor = .mainWhite()
		
		aboutLabel.numberOfLines = 0
		
		if let button = textField.rightView as? UIButton {
			button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
		}
	
		imageView.translatesAutoresizingMaskIntoConstraints = false
		aboutLabel.translatesAutoresizingMaskIntoConstraints = false
		textField.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		container.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(imageView)
		view.addSubview(container)
		container.addSubview(nameLabel)
		container.addSubview(aboutLabel)
		container.addSubview(textField)
		
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: view.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: container.topAnchor, constant: 30),
			
			container.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			container.heightAnchor.constraint(equalToConstant: 206),
			
			nameLabel.topAnchor.constraint(equalTo: container.topAnchor,constant: 35),
			nameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor,constant: 24),
			nameLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor,constant: -24),
			
			aboutLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,constant: 8),
			aboutLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor,constant: 24),
			aboutLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor,constant: -24),
			
			textField.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor,constant: 8),
			textField.leadingAnchor.constraint(equalTo: container.leadingAnchor,constant: 24),
			textField.trailingAnchor.constraint(equalTo: container.trailingAnchor,constant: -24),
			textField.heightAnchor.constraint(equalToConstant: 48)
			
		])
	}
	
	@objc func sendMessage() {
		print(#function)
		
		guard let message = textField.text, message != "" else { return }
		
		self.dismiss(animated: true) {
			FirestoreService.shared.createWaitingChat(message: message, receiver: self.user) { result in
				guard let topVC = UIApplication.getTopViewController() as? BaseVC else { return }
				
				switch result {
				case .success():
					topVC.showAlert(message: "Your message for \(self.user.username) has been sent", title: "Successfully" )
					
				case .failure(let error):
					
					topVC.showAlert(message: error.localizedDescription)
					
				}
			}
		}
	}
}

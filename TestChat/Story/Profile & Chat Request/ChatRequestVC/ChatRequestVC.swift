//
//  ChatRequestVC.swift
//  TestChat
//
//  Created by Матвей Чернышев on 17.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit
import SDWebImage

final class ChatRequestVC : BaseVC {
	
	init(chat: MChat) {
		self.chat = chat
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
	}
	override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		acceptButton.applyGradients(cornerRadius: 10)
	}
	
	private let chat: MChat
	weak var delegate: WaitingChatsNavigation?
	
	private lazy var nameLabel = UILabel(
		text: chat.friendUserName,
		font: .systemFont(ofSize: 20, weight: .light)
	)
	private lazy var aboutLabel = UILabel(
		text: "You have the oportunity to start a new chat",
		font: .systemFont(ofSize: 16, weight: .light)
	)
	private lazy var acceptButton = UIButton(
		title: "ACCEPT",
		titleColor: .white,
		font: .laoSangamMN20(),
		backgroundColor: .black,
		isShadow: false,
		cornerRadius: 10
	)
	private lazy var denyButton = UIButton(
		title: "Deny",
		titleColor: .red,
		font: .laoSangamMN20(),
		backgroundColor: .black,
		isShadow: false,
		cornerRadius: 10
	)
	private lazy var stackView = UIStackView(
		arranged: [acceptButton, denyButton],
		axis: .horizontal,
		spacing: 7
	)
	private lazy var container = UIView()
	private lazy var imageView = UIImageView()
}

private extension ChatRequestVC {
	
	@objc func denyButtonTapped() {
		self.dismiss(animated: true) {
			self.delegate?.removeWaitingChats(chat: self.chat)
		}
	}
	
	@objc func acceptButtonTapped() {
		self.dismiss(animated: true) {
			self.delegate?.chatToActive(chat: self.chat)
		}
	}
	
	func setupUI() {
		denyButton.addTarget(self, action: #selector(denyButtonTapped), for: .touchUpInside)
		acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
		
		imageView.contentMode = .scaleAspectFill
		imageView.sd_setImage(with: URL(string: chat.friendAvatarStringURl), completed: nil)
		
		denyButton.layer.borderWidth = 1.2
		denyButton.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
		denyButton.applyGradients(cornerRadius: 10)
		
		stackView.distribution = .fillEqually
		
		container.backgroundColor = .mainWhite()
		container.layer.cornerRadius = 30
		
		stackView.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		aboutLabel.translatesAutoresizingMaskIntoConstraints = false
		imageView.translatesAutoresizingMaskIntoConstraints = false
		container.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(imageView)
		view.addSubview(container)
		container.addSubview(nameLabel)
		container.addSubview(stackView)
		container.addSubview(aboutLabel)
		
		
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: view.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: container.topAnchor),
			
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
			
			stackView.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor,constant: 24),
			stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor,constant: 24),
			stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor,constant: -24),
			stackView.heightAnchor.constraint(equalToConstant: 56)
			
		])
	}
}

//
//  ActiveChatCell.swift
//  TestChat
//
//  Created by Матвей Чернышев on 14.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

final class ActiveChatCell: UICollectionViewCell {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private lazy var friendImageView = UIImageView()
	private lazy var friendName = UILabel(text: "User name", font: .laoSangamMN20())
	private lazy var lastMessage = UILabel(text: "WhatsUp", font: .laoSangamMN18())
	private lazy var gradientView = Gradient(origin: .topTrailing, endPoint: .bottomLeading, startColor: #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1), endColor: #colorLiteral(red: 0.4784313725, green: 0.6980392157, blue: 0.9215686275, alpha: 1))
}

extension ActiveChatCell: SelfConfiguringCellProtocol {
	static var reuseID: String = "ActiveChatCell"
	
	func configure<U>(with value: U) where U : Hashable {
		guard let chat: MChat = value as? MChat else { return }
		
		friendImageView.sd_setImage(with: URL(string: chat.friendAvatarStringURl), completed: nil)
		friendName.text = chat.friendUserName
		lastMessage.text = chat.lastMessageContent
	}
}

private extension ActiveChatCell {
	
	func setupUI() {
		layer.cornerRadius = 4
		clipsToBounds = true
		
		friendImageView.backgroundColor = .brown
		gradientView.backgroundColor = .magenta
		backgroundColor = .white
		
		friendImageView.backgroundColor = .brown
		gradientView.backgroundColor = .magenta
		backgroundColor = .white
		
		friendImageView.translatesAutoresizingMaskIntoConstraints = false
		friendName.translatesAutoresizingMaskIntoConstraints = false
		lastMessage.translatesAutoresizingMaskIntoConstraints = false
		gradientView.translatesAutoresizingMaskIntoConstraints = false

		addSubview(friendImageView)
		addSubview(gradientView)
		addSubview(friendName)
		addSubview(lastMessage)
		
		NSLayoutConstraint.activate([
			friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			friendImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			friendImageView.widthAnchor.constraint(equalToConstant: 78),
			friendImageView.heightAnchor.constraint(equalToConstant: 78),
			
			friendName.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
			friendName.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
			friendName.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16),
			
			lastMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
			lastMessage.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
			lastMessage.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 16),
			
			gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			gradientView.widthAnchor.constraint(equalToConstant: 8),
			gradientView.heightAnchor.constraint(equalToConstant: 78),
		])
	}
}

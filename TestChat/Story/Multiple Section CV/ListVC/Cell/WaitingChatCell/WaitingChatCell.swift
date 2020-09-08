//
//  WaitingChatCell.swift
//  TestChat
//
//  Created by Матвей Чернышев on 15.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

final class WaitingChatCell: UICollectionViewCell {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private let friendImageView = UIImageView()
}


extension WaitingChatCell: SelfConfiguringCellProtocol {
	static var reuseID: String = WaitingChatCell.reuseIdentifier
	
	func configure<U>(with value: U) where U : Hashable {
		
		guard let chat: MChat = value as? MChat else { return }
		friendImageView.sd_setImage(with: URL(string: chat.friendAvatarStringURl), completed: nil)
	}
}

private extension WaitingChatCell {
	
	func setupUI() {
		layer.cornerRadius = 4
		clipsToBounds = true
		backgroundColor = .red
		
		friendImageView.translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(friendImageView)
		
		NSLayoutConstraint.activate(friendImageView.edgeConstraints(to: self))
	}
}

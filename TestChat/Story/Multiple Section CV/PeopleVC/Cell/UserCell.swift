//
//  UserCell.swift
//  TestChat
//
//  Created by Матвей Чернышев on 16.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit
import SDWebImage

final class UserCell: UICollectionViewCell {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		self.layer.layoutIfNeeded()
		self.layer.cornerRadius = 4
		self.contentView.clipsToBounds = true
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		userImageView.image = nil
	}
	
	private lazy var userImageView = UIImageView()
	private lazy var userLabel = UILabel(text: "text", font: .laoSangamMN20())
}

extension UserCell: SelfConfiguringCellProtocol {
	static var reuseID: String = UserCell.reuseIdentifier
	
	func configure<U>(with value: U) where U : Hashable {
		guard
			let user: MUser = value as? MUser,
			let url  = URL(string: user.avatarStringURL) else { return }
		
		userLabel.text = user.username
		userImageView.sd_setImage(with: url, completed: nil)
	}
}

private extension UserCell {
	
	func setupUI() {
		backgroundColor = .white
		
		layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
		layer.shadowRadius = 3
		layer.shadowOpacity = 0.5
		layer.shadowOffset = CGSize(width: 0, height: 4)
		
		userImageView.translatesAutoresizingMaskIntoConstraints = false
		userLabel.translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(userImageView)
		addSubview(userLabel)
		
		NSLayoutConstraint.activate([
			userImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
			userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			userImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			userImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
			
			userLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
			userLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
			userLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
			userLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])
	}
}

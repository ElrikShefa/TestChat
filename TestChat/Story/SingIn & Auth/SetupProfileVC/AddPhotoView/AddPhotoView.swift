//
//  AddPhotoView.swift
//  TestChat
//
//  Created by Матвей Чернышев on 10.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

final class AddPhotoView: UIView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		circleImageView.layoutIfNeeded()
		circleImageView.layer.cornerRadius = circleImageView.frame.width * 0.5
	}
	
	lazy var circleImageView = UIImageView()
	lazy var plusButton = UIButton(type: .system)
}

private extension AddPhotoView {
	func setupUI() {
		
		circleImageView.image = #imageLiteral(resourceName: "avatar-4")
		circleImageView.contentMode = .scaleAspectFill
		circleImageView.layer.masksToBounds = true
		circleImageView.clipsToBounds = true
		circleImageView.layer.borderColor = UIColor.black.cgColor
		circleImageView.layer.borderWidth = 1
		
		plusButton.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
		plusButton.tintColor = .buttonDark()
		
		plusButton.translatesAutoresizingMaskIntoConstraints = false
		circleImageView.translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(circleImageView)
		addSubview(plusButton)
		
		NSLayoutConstraint.activate([
			circleImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
			circleImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
			circleImageView.widthAnchor.constraint(equalToConstant: 100),
			circleImageView.heightAnchor.constraint(equalToConstant: 100),
			
			plusButton.leadingAnchor.constraint(equalTo: circleImageView.trailingAnchor, constant: 16),
			plusButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			plusButton.widthAnchor.constraint(equalToConstant: 30),
			plusButton.heightAnchor.constraint(equalToConstant: 30),
			
			self.bottomAnchor.constraint(equalTo: circleImageView.bottomAnchor),
			self.trailingAnchor.constraint(equalTo: plusButton.trailingAnchor)
		])
	}
}

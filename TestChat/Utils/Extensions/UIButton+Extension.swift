//
//  UIButton+Extension.swift
//  TestChat
//
//  Created by Матвей Чернышев on 06.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

extension UIButton {
	
	convenience init(
		title: String,
		titleColor: UIColor,
		font: UIFont? = .avenir20(),
		backgroundColor: UIColor,
		isShadow: Bool,
		cornerRadius: CGFloat = 4
	) {
		self.init(type: .system)
		
		self.setTitle(title, for: .normal)
		self.setTitleColor(titleColor, for: .normal)
		self.backgroundColor = backgroundColor
		self.titleLabel?.font = font
		
		self.layer.cornerRadius = cornerRadius
		
		if isShadow {
			self.layer.shadowColor = UIColor.black.cgColor
			self.layer.shadowRadius = 4
			self.layer.shadowOpacity = 0.2
			self.layer.shadowOffset = CGSize(width: 0, height: 4)
		}
	}
}

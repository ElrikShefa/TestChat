//
//  UIImageView+Extension.swift
//  TestChat
//
//  Created by Матвей Чернышев on 06.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

extension UIImageView {
	
	convenience init(image: UIImage?, contentMode: UIView.ContentMode) {
		self.init()
		
		self.image = image
		self.contentMode = contentMode
	}
}

extension UIImageView {
	
	func setupColor(color: UIColor) {
		let  templateImage = self.image?.withRenderingMode(.alwaysTemplate)
		self.image = templateImage
		self.tintColor = color
	}
}

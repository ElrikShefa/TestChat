//
//  UILabel+Extension.swift
//  TestChat
//
//  Created by Матвей Чернышев on 06.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

extension UILabel {
	
	convenience init(text: String, font: UIFont? = .avenir20()) {
		self.init()
		
		self.text = text
		self.font = font
	}
}

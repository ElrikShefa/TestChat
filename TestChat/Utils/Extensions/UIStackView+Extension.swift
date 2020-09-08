//
//  UIStackView+Extension.swift
//  TestChat
//
//  Created by Матвей Чернышев on 07.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

extension UIStackView {
	
	convenience init(
		arranged: [UIView],
		axis: NSLayoutConstraint.Axis = .vertical,
		spacing: CGFloat = 0
	){
		self.init(arrangedSubviews: arranged)
		self.axis = axis
		self.spacing = spacing
	}
}

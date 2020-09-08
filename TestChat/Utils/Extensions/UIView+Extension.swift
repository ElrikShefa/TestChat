//
//  UIView+Extension.swift
//  TestChat
//
//  Created by Матвей Чернышев on 16.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

extension UIView {
	
	static var reuseIdentifier: String {
		return String(describing: self)
	}
	
	static var nibName: String {
		return String(describing: self)
	}
}

extension UIView {
	
	func applyGradients(cornerRadius: CGFloat) {
        self.backgroundColor = nil
        self.layoutIfNeeded()
		
        let gradientView = Gradient(origin: .topTrailing, endPoint: .bottomLeading, startColor: #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1), endColor: #colorLiteral(red: 0.4784313725, green: 0.6980392157, blue: 0.9215686275, alpha: 1))
		
        if let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.bounds
            gradientLayer.cornerRadius = cornerRadius
            
            self.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}

extension UIView {
	
	func edgeConstraints(
		to view: UIView,
		insets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
	) -> [NSLayoutConstraint] {
		
		translatesAutoresizingMaskIntoConstraints = false
		
		let topConstraint = topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top)
		let leftConstraint = leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left)
		let bottomConstraint = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
		let rightConstraint = rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right)
		
		return [topConstraint, leftConstraint, bottomConstraint, rightConstraint]
	}

	func edgeConstraints(
		to layoutGuide: UILayoutGuide,
		insets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
	) -> [NSLayoutConstraint] {
		
		translatesAutoresizingMaskIntoConstraints = false
		
		let topConstraint = topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: insets.top)
		let leftConstraint = leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: insets.left)
		let bottomConstraint = bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -insets.bottom)
		let rightConstraint = rightAnchor.constraint(equalTo: layoutGuide.rightAnchor, constant: -insets.right)
		
		return [topConstraint, leftConstraint, bottomConstraint, rightConstraint]
	}
}

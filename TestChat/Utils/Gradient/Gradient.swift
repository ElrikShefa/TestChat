//
//  Gradient.swift
//  TestChat
//
//  Created by Матвей Чернышев on 14.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

final class Gradient: UIView {
	
	init(origin: Point, endPoint: Point, startColor: UIColor?, endColor: UIColor?) {
		self.init()
		setupGradient(origin: origin, endPoint: endPoint, startColor: startColor, endColor: endColor)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupGradient(origin: .leading, endPoint: .trailing, startColor: startColor, endColor: endColor)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		gradientLayer.frame = bounds
	}
	
	private let gradientLayer = CAGradientLayer()
	
	@IBInspectable private var startColor: UIColor? {
		didSet {
			setupGradientColor(startColor: startColor, endColor: endColor)
		}
	}
	
	@IBInspectable private var endColor: UIColor? {
		didSet {
			setupGradientColor(startColor: startColor, endColor: endColor)
		}
	}
}

private extension Gradient {
	
	func setupGradient(origin: Point, endPoint: Point, startColor: UIColor?, endColor: UIColor?) {
		self.layer.addSublayer(gradientLayer)
		
		setupGradientColor( startColor: startColor, endColor: endColor)
		
		gradientLayer.startPoint = origin.point
		gradientLayer.endPoint = endPoint.point
	}
	
	func setupGradientColor( startColor: UIColor?, endColor: UIColor?) {
		if let startColor = startColor, let endColor = endColor {
			gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
		}
	}
}

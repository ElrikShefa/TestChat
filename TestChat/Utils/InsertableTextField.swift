//
//  InsertableTextField.swift
//  TestChat
//
//  Created by Матвей Чернышев on 17.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

final class InsertableTextField: UITextField {
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension InsertableTextField {
	
	override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
		var rect = super.leftViewRect(forBounds: bounds)
		rect.origin.x += 12
		return rect
	}
	
	override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
		var rect = super.rightViewRect(forBounds: bounds)
		rect.origin.x -= 12
		return rect
	}
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: 36, dy: 0)
	}
	
	override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: 36, dy: 0)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: 36, dy: 0)
	}
}

private extension InsertableTextField {
	
	func setupUI() {
		
		backgroundColor = .white
		placeholder = "White something here..."
		font = .systemFont(ofSize: 14)
		clearButtonMode = .whileEditing
		borderStyle = .none
		layer.cornerRadius = 18
		layer.masksToBounds = true
		
		let imageView = UIImageView(image: UIImage(systemIcon: .smiley))
		imageView.setupColor(color: .lightGray)
		
		leftView = imageView
		leftView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
		leftViewMode = .always
		
		let button = UIButton(type: .system)
		button.setImage(UIImage(named: "Sent"), for: .normal)
		button.applyGradients(cornerRadius: 18)
		
		rightView = button
		rightView?.frame = CGRect(x: 0, y: 0, width: 19, height: 19)
		rightViewMode = .always
	}
}

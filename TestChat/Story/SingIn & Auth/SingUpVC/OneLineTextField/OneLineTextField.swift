//
//  OneLineTextField.swift
//  TestChat
//
//  Created by Матвей Чернышев on 07.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

final class OneLineTextField: UITextField {
	
	convenience init(font: UIFont? = .avenir20()){
		self.init()
		
		self.font = font
		self.borderStyle = .none
		self.translatesAutoresizingMaskIntoConstraints = false
		
		let bottomView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
		bottomView.backgroundColor = .textFieldLight()
		bottomView.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(bottomView)
		
		NSLayoutConstraint.activate([
			bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			bottomView.heightAnchor.constraint(equalToConstant: 1)
		])
	}
}

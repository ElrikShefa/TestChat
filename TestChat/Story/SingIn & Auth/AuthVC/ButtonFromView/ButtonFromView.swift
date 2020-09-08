//
//  ButtonFromView.swift
//  TestChat
//
//  Created by Матвей Чернышев on 07.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

final class ButtonFromView: UIView {
	
	init(label: UILabel, button: UIButton) {
		super.init(frame: .zero)
		
		self.translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false
		button.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(label)
		self.addSubview(button)
		
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: self.topAnchor),
			label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			
			button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
			button.leadingAnchor.constraint(equalTo: label.leadingAnchor),
			button.trailingAnchor.constraint(equalTo: label.trailingAnchor),
			button.heightAnchor.constraint(equalToConstant: 60),
			
			self.bottomAnchor.constraint(equalTo: button.bottomAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

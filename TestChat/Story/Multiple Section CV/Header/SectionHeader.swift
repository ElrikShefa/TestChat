//
//  SectionHeader.swift
//  TestChat
//
//  Created by Матвей Чернышев on 15.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

final class SectionHeader: UICollectionReusableView {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
 static let reuseId = "SectionHeader"
	
	private lazy var title = UILabel()
}

private extension SectionHeader {
	
	func setupUI() {
		title.translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(title)
		
		NSLayoutConstraint.activate(title.edgeConstraints(to: self))
	}
}

extension SectionHeader {
	
	func configure(text: String, font: UIFont?, textColor: UIColor) {
		title.text = text
		title.font = font
		title.textColor = textColor
	}
}

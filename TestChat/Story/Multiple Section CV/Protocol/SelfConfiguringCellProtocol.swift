//
//  SelfConfiguringCellProtocol.swift
//  TestChat
//
//  Created by Матвей Чернышев on 14.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

protocol SelfConfiguringCellProtocol {
	
	static var reuseID: String { get }
	
	func configure<U: Hashable>(with value: U)
}

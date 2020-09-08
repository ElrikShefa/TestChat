//
//  SegmentedControl+Extension.swift
//  TestChat
//
//  Created by Матвей Чернышев on 10.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

extension UISegmentedControl {
	
	convenience init(first: String, second: String) {
		self.init()
		
		self.insertSegment(withTitle: first, at: 0, animated: true)
		self.insertSegment(withTitle: second, at: 1, animated: true)
		self.selectedSegmentIndex = 0
	}
}

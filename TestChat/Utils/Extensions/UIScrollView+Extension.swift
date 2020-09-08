//
//  UIScrollView+Extension.swift
//  TestChat
//
//  Created by Матвей Чернышев on 02.07.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

extension UIScrollView {
	
	var isAtBottom: Bool {
		   return contentOffset.y >= verticalOffsetForBottom
	   }
	
	var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
	
}

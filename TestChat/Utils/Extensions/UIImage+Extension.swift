//
//  UIImage+Extension.swift
//  TestChat
//
//  Created by Матвей Чернышев on 12.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

enum SystemIcon: String {
	
	case heart = "heart"
	case heartFill = "heart.fill"
	case person2 = "person.2"
	case conversation = "bubble.left.and.bubble.right"
	case smiley = "smiley"
	case camera = "camera"
}

extension UIImage {
	
	convenience init(systemIcon: SystemIcon) {
		self.init(systemName: systemIcon.rawValue, withConfiguration: UIImage.SymbolConfiguration(weight: .medium))!
	}
	
	var scaledToSafeUploadSize: UIImage? {
		let maxImageSideLength: CGFloat = 480
		
		let largerSide: CGFloat = max(size.width, size.height)
		let ratioScale: CGFloat = largerSide > maxImageSideLength ? largerSide / maxImageSideLength : 1
		let newImageSize = CGSize(width: size.width / ratioScale, height: size.height / ratioScale)
		
		return image(scaledTo: newImageSize)
	}
	
	final func image(scaledTo size: CGSize) -> UIImage? {
		defer {
			UIGraphicsEndImageContext()
		}
		
		UIGraphicsBeginImageContextWithOptions(size, true, 0)
		draw(in: CGRect(origin: .zero, size: size))
		
		return UIGraphicsGetImageFromCurrentImageContext()
	}
}

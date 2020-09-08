//
//  UIApplication+Extension.swift
//  TestChat
//
//  Created by Матвей Чернышев on 23.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

extension UIApplication {
	
	class func getTopViewController(
		base: UIViewController? = UIWindow.key?.rootViewController
	) -> UIViewController? {
		
		if let nav = base as? UINavigationController {
			return getTopViewController(base: nav.visibleViewController)
			
		} else if
			let tabBar = base as? UITabBarController,
			let selected = tabBar.selectedViewController {
			
			return getTopViewController(base: selected)
			
		} else if let presented = base?.presentedViewController {
			return getTopViewController(base: presented)
		}
		return base
	}
}

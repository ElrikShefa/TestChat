//
//  MessagesViewController+Extenion.swift
//  TestChat
//
//  Created by Матвей Чернышев on 02.07.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import MessageKit

extension MessagesViewController {
	
	final func showAlert(
		message: String,
		title: String = "Error has occured",
		actions: [UIAlertAction] = [],
		completion: @escaping () -> Void = {}
	) {
		guard Thread.isMainThread else {
			DispatchQueue.main.async { [weak self] in
				self?.showAlert(message: message, title: title, actions: actions)
			}
			
			return
		}
		
		let alertController = UIAlertController(
			title: title,
			message: message,
			preferredStyle: .alert
		)
		
		var resultActions: [UIAlertAction] = []
		
		if actions.isNotEmpty {
			resultActions = actions
		} else {
			let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
				completion()
			}
			
			resultActions = [okAction]
		}
		
		resultActions.forEach(alertController.addAction(_:))
		
		present(alertController, animated: true, completion: nil)
	}
}

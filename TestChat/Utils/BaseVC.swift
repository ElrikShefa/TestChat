//
//  BaseVC.swift
//  TestChat
//
//  Created by Матвей Чернышев on 12.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
	
	final var viewDidAppear = false
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		viewDidAppear = true
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		viewDidAppear = false
	}
}

extension BaseVC {
	
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
		
		present(alertController, animated: viewDidAppear, completion: nil)
	}
	
	final func configure<T: SelfConfiguringCellProtocol, U: Hashable>(
		view: UICollectionView,
		cellType: T.Type,
		with value: U,
		for indexPath: IndexPath
	) -> T {
		guard let cell = view.dequeueReusableCell(
			withReuseIdentifier: cellType.reuseID,
			for: indexPath) as? T else {
				fatalError("Unable to dequeue \(cellType)")}
		cell.configure(with: value)
		return cell
	}
}

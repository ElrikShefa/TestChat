//
//  SearchVC.swift
//  TestChat
//
//  Created by Матвей Чернышев on 12.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit

class SearchVC: BaseVC {}

extension SearchVC {
	
	final func makeSearchVC() -> UISearchController {
		let searchVC = UISearchController(searchResultsController: nil)

		searchVC.hidesNavigationBarDuringPresentation = false
		searchVC.obscuresBackgroundDuringPresentation = false
		searchVC.searchBar.delegate = self
		
		return searchVC
	}
}

extension SearchVC: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		print("")
	}
}

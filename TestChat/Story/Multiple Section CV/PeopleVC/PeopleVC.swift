//
//  PeopleVC.swift
//  TestChat
//
//  Created by Матвей Чернышев on 12.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class PeopleVC: SearchVC {
	
	init(currentUser: MUser) {
		self.currentUser = currentUser
		super.init(nibName: nil, bundle: nil)
		title = currentUser.username
	}
	
	deinit {
		usersListener?.remove()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		makeDataSourse()
		
		usersListener = ListenerService.shared.usersObserve(users: users, comletion: { result in
			
			switch result {
			case .success(let users):
				self.users = users
				self.reloadData(nil)
				
			case .failure(let error):
				self.showAlert(message: error.localizedDescription)
			}
		})
	}
	
	private	lazy var collectionView = UICollectionView(
		frame: view.bounds,
		collectionViewLayout: createCompositionalLayout()
	)
	
	private typealias CellType = UserCell
	
	private var users = [MUser]()
	private var usersListener: ListenerRegistration?
	private let currentUser: MUser
	private var dataSourse: UICollectionViewDiffableDataSource<SectionPeopleVC, MUser>!
}

private extension PeopleVC {
	
	func createCompositionalLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout {
			(sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			
			guard let section = SectionPeopleVC(rawValue: sectionIndex) else {
				fatalError("Unknown section kind")
			}
			switch section {
			case .users:
				return self.makeUsersSection()
			}
		}
		
		let config = UICollectionViewCompositionalLayoutConfiguration()
		config.interSectionSpacing = 20
		layout.configuration = config
		return layout
	}
	
	func makeDataSourse() {
		
		dataSourse = UICollectionViewDiffableDataSource<SectionPeopleVC, MUser>(
			collectionView: collectionView,
			cellProvider: { ( collectionView, indexPath, chat) -> UICollectionViewCell? in
				
				guard let section = SectionPeopleVC(rawValue: indexPath.section) else {
					fatalError("Unknown section kind")
				}
				
				switch section {
				case .users:
					return self.configure(view: collectionView, cellType: CellType.self, with: chat, for: indexPath)
				}
		})
		
		dataSourse?.supplementaryViewProvider = {
			
			collectionView, kind, indexPath in
			
			guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: SectionHeader.reuseId,
				for: indexPath
				) as? SectionHeader else {
				self.showAlert(message: "Can't create new section header")
				return nil
			}
			
			guard let section = SectionPeopleVC(rawValue: indexPath.section) else {
				self.showAlert(message: "Unknown section kind")
				return nil
			}
			
			let items = self.dataSourse.snapshot().itemIdentifiers(inSection: .users)
			sectionHeader.configure(
				text: section.description(usersCount: items.count),
				font: .systemFont(ofSize: 36, weight: .light),
				textColor: .label
			)
			
			return sectionHeader
		}
	}
	
	func reloadData(_ searchText: String?) {
		let filtered = users.filter { (user) -> Bool in
			user.contains(filter: searchText)
		}
		
		var snapshot = NSDiffableDataSourceSnapshot<SectionPeopleVC, MUser>()
		
		snapshot.appendSections([.users])
		snapshot.appendItems(filtered, toSection: .users)
		
		dataSourse?.apply(snapshot, animatingDifferences: true)
	}
	
	func makeUsersSection() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
											  heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
											   heightDimension: .fractionalWidth(0.6))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
		group.interItemSpacing = .fixed(15)
		
		let section = NSCollectionLayoutSection(group: group)
		section.interGroupSpacing = 15
		section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 15, bottom: 0, trailing: 15)
		
		let sectionHeader = makeSectionHeader()
		section.boundarySupplementaryItems = [sectionHeader]
		return section
	}
	
	func setupUI() {
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(singOut))
		navigationItem.searchController = makeSearchVC()
		navigationItem.hidesSearchBarWhenScrolling = false
		
		navigationController?.navigationBar.barTintColor = .mainWhite()
		navigationController?.navigationBar.shadowImage = UIImage()
		
		collectionView.backgroundColor = .mainWhite()
		collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		
		collectionView.delegate = self
		collectionView.register(CellType.self, forCellWithReuseIdentifier: CellType.reuseIdentifier)
		
		collectionView.register(
			SectionHeader.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: SectionHeader.reuseId
		)
		
		view.addSubview(collectionView)
	}
	
	@objc func singOut() {
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		let singOut = UIAlertAction(title: "Sing Out", style: .destructive, handler: { (_) in
			do {
				try Auth.auth().signOut()
				UIWindow.key?.rootViewController = AuthVC()
			} catch {
				print("Error sing out: \(error.localizedDescription)")
			}
		})
		showAlert(message: "Do you really want to leave?", title: "", actions: [cancel, singOut])
	}
}

private extension PeopleVC {
	
	func makeSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
		
		let sectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
													   heightDimension: .estimated(1))
		return NSCollectionLayoutBoundarySupplementaryItem(
			layoutSize: sectionHeaderSize,
			elementKind: UICollectionView.elementKindSectionHeader,
			alignment: .top
		)
	}
}

extension PeopleVC {
	
	override func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		reloadData(searchText)
	}
}

extension PeopleVC: UICollectionViewDelegate {
	
	func collectionView(
		_ collectionView: UICollectionView,
		didSelectItemAt indexPath: IndexPath
	) {
		guard let user = self.dataSourse.itemIdentifier(for: indexPath)  else { return }
		let profileVC = ProfileVC(user: user)
		present(profileVC, animated: true, completion: nil)
	}
}

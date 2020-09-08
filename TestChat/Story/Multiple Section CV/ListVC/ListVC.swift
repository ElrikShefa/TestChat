//
//  ListVC.swift
//  TestChat
//
//  Created by Матвей Чернышев on 12.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import UIKit
import FirebaseFirestore

final class ListVC: SearchVC {
	
	init(currentUser: MUser) {
		self.currentUser = currentUser
		super.init(nibName: nil, bundle: nil)
		title = currentUser.username
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	deinit {
		waitingChatsListener?.remove()
		activeChatsListener?.remove()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		setupUI()
		makeDataSource()
		reloadData()
		
		waitingChatsListener = ListenerService.shared.waitingChatsObserve(
			chats: waitingChats,
			comletion: { result in
			
				switch result {
				case .success(let chat):
					
					if self.waitingChats.isNotEmpty, self.waitingChats.count <= chat.count {
						guard let chat = chat.last else { return }
						
						let chatRequestVC = ChatRequestVC(chat: chat)
						chatRequestVC.delegate = self
						self.present(chatRequestVC, animated: true, completion: nil)
					}
					
					self.waitingChats = chat
					self.reloadData()
					
				case .failure(let error):
					self.showAlert(message: error.localizedDescription)
				}
		})
		
		activeChatsListener = ListenerService.shared.activeChatsObserve(
			chats: activeChats,
			comletion: { result in
			
				switch result {
				case .success(let chat):
					self.activeChats = chat
					self.reloadData()
					
				case .failure(let error):
					self.showAlert(message: error.localizedDescription)
				}
		})
	}
	
	private	lazy var collectionView = UICollectionView(
		frame: view.bounds,
		collectionViewLayout: createCompositionalLayout()
	)
	private let currentUser: MUser
	
	private var dataSourse: UICollectionViewDiffableDataSource<SectionListVC, MChat>?
//	MARK:- WTF?
	private var activeChats = [MChat]()
	private var waitingChats = [MChat]()
	
	//	MARK:- WTF?
	private var waitingChatsListener: ListenerRegistration?
	private var activeChatsListener: ListenerRegistration?
}

extension ListVC: UICollectionViewDelegate {
	
	func collectionView(
		_ collectionView: UICollectionView,
		didSelectItemAt indexPath: IndexPath
	) {
		guard
			let chat = self.dataSourse?.itemIdentifier(for: indexPath),
			let section = SectionListVC(rawValue: indexPath.section) else { return }
		
		switch section {
		case .waitingChats:
			let chatRequestVC = ChatRequestVC(chat: chat)
			chatRequestVC.delegate = self
			self.present(chatRequestVC, animated: true, completion: nil)
			
		case .activeChats:
			let chatcVC = ChatsVC(user: currentUser, chat: chat)
			navigationController?.pushViewController(chatcVC, animated: true)
		}
	}
}

extension ListVC: WaitingChatsNavigation {
	func removeWaitingChats(chat: MChat) {
		FirestoreService.shared.deleteWaitingChat(chat: chat) { result in
			
			switch result {
			case .success():
				self.showAlert(message: "Chat with \(chat.friendUserName) has been deleted ", title: "Successe")
				
			case .failure(let error):
				self.showAlert(message: error.localizedDescription)
			}
		}
	}
	
	func chatToActive(chat: MChat) {
		FirestoreService.shared.changeToActive(chat: chat) { result in
			
			switch result {
			case .success():
				self.showAlert(message: "Nice conversation with \(chat.friendUserName).", title: "Successe!")
				
			case .failure(let error):
				self.showAlert(message: error.localizedDescription)
			}
		}
	}
}

private extension ListVC {
	
	func makeDataSource() {
		dataSourse = UICollectionViewDiffableDataSource<SectionListVC, MChat>(
			collectionView: collectionView,
			cellProvider: { ( collectionView, indexPath, chat) -> UICollectionViewCell? in
				guard let section = SectionListVC(rawValue: indexPath.section) else {
					fatalError("Unknown section kind")
				}
				
				switch section {
				case .activeChats:
					return self.configure(view: collectionView, cellType: ActiveChatCell.self, with: chat, for: indexPath)
					
				case .waitingChats:
					return self.configure(view: collectionView, cellType: WaitingChatCell.self, with: chat, for: indexPath)
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
			
			guard let section = SectionListVC(rawValue: indexPath.section) else {
				self.showAlert(message: "Unknown section kind")
				return nil
			}
			
			sectionHeader.configure(text: section.description(), font: .laoSangamMN20(), textColor: #colorLiteral(red: 0.5725490196, green: 0.5725490196, blue: 0.5725490196, alpha: 1))
			
			return sectionHeader
		}
	}
	
	func reloadData() {
		var snapshot = NSDiffableDataSourceSnapshot<SectionListVC, MChat>()
		
		snapshot.appendSections([.waitingChats, .activeChats])
		snapshot.appendItems(waitingChats, toSection: .waitingChats)
		snapshot.appendItems(activeChats, toSection: .activeChats)
		
		dataSourse?.apply(snapshot, animatingDifferences: true)
	}
}

private extension ListVC {
	
	func createCompositionalLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout {
			(sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
			
			guard let section = SectionListVC(rawValue: sectionIndex) else {
				fatalError("Unknown section kind")
			}
			switch section {
				
			case .activeChats:
				return self.createActiveChats()
			case .waitingChats:
				return self.createWaitingChats()
			}
		}
		
		let config = UICollectionViewCompositionalLayoutConfiguration()
		config.interSectionSpacing = 20
		layout.configuration = config
		return layout
	}
	
	func createWaitingChats() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
											  heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88),
											   heightDimension: .absolute(88))
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
													   subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.interGroupSpacing = 16
		section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
		section.orthogonalScrollingBehavior = .continuous
		section.boundarySupplementaryItems = [makeSectionHeader()]
		
		return section
	}
	
	func createActiveChats() -> NSCollectionLayoutSection {
		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
											  heightDimension: .fractionalHeight(1))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
											   heightDimension: .absolute(78))
		let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
													 subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		section.interGroupSpacing = 8
		section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
		section.boundarySupplementaryItems = [makeSectionHeader()]
		
		return section
	}
	
	func setupUI() {
		navigationItem.searchController = makeSearchVC()
		navigationItem.hidesSearchBarWhenScrolling = false
		
		navigationController?.navigationBar.barTintColor = .mainWhite()
		navigationController?.navigationBar.shadowImage = UIImage()
		
		collectionView.backgroundColor = .mainWhite()
		collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		
		collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseID)
		collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseID)
		
		collectionView.delegate = self
		collectionView.register(
			SectionHeader.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: SectionHeader.reuseId
		)

		view.addSubview(collectionView)
	}
}

private extension ListVC {
	
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

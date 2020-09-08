//
//  SectionListVC.swift
//  TestChat
//
//  Created by Матвей Чернышев on 13.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//


enum SectionListVC: Int, CaseIterable {
	case waitingChats
	case activeChats
}

extension SectionListVC {
	func description() -> String {
		switch self {
			
		case .waitingChats:
			return "Waiting chats"
		case .activeChats:
			return "Active chats"
		}
	}
}

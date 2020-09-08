//
//  WaitingChatsNavigation.swift
//  TestChat
//
//  Created by Матвей Чернышев on 29.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import Foundation

protocol WaitingChatsNavigation: class {
	
	func removeWaitingChats(chat: MChat)
	
	func chatToActive(chat: MChat)
}

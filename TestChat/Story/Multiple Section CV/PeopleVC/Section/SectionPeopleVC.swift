//
//  SectionPeopleVC.swift
//  TestChat
//
//  Created by Матвей Чернышев on 15.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

enum SectionPeopleVC: Int, CaseIterable {
	case users
}

extension SectionPeopleVC {
	func description(usersCount: Int) -> String {
		switch self {
			
		case .users:
			return "\(usersCount) people nearby"
		}
	}
}

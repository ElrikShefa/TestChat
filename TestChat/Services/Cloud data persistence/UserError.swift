//
//  UserError.swift
//  TestChat
//
//  Created by Матвей Чернышев on 19.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import Foundation

enum UserError {
	case notFilled
	case photoNotExist
	case notDeployMUSer
	case missingInfo
}

extension UserError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .notFilled:
			return NSLocalizedString("Заполните все поля", comment: "")
		case .photoNotExist:
			return NSLocalizedString("User did not select photo", comment: "")
		case .missingInfo:
			return NSLocalizedString("It isn't possible to download info about user",
									 comment: "")
		case .notDeployMUSer:
			return NSLocalizedString("impossible to convert  MUser from MUser", comment: "")
		}
	}
}

//
//  AuthError.swift
//  TestChat
//
//  Created by Матвей Чернышев on 18.06.2020.
//  Copyright © 2020 Matvey Chernyshov. All rights reserved.
//

import Foundation

enum AuthError {
	case notFilled
	case invalidEmail
	case passwordNotMatches
	case unknownError
	case serverError
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Заполните все поля", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Формат почты не является допустимым", comment: "")
        case .passwordNotMatches:
            return NSLocalizedString("Пароли не совпадают", comment: "")
        case .unknownError:
            return NSLocalizedString("Неизвестная ошибка", comment: "")
        case .serverError:
            return NSLocalizedString("Ошибка сервера", comment: "")
        }
    }
}

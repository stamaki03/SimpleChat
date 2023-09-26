//
//  FAErrorCheck.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/25.
//

import Foundation
import FirebaseAuth

final class FAErrorCheck {
    static let shared = FAErrorCheck()
    private init() {}
    
    func signUpValidationCheck(error: Error) -> String {
        if let errorCode = AuthErrorCode.Code(rawValue: error._code) {
            switch errorCode {
            case .invalidEmail:
                return "メールアドレスの形式が違います"
            case .weakPassword, .userNotFound, .wrongPassword:
                return "メールアドレスまたはパスワードが間違っています"
            case .userDisabled:
                return "このユーザーアカウントは無効化されています"
            default:
                return "ログインできません"
            }
        }
        return "エラーが発生しました"
    }
    
    func loginValidationCheck(error: Error) -> String {
        if let errorCode = AuthErrorCode.Code(rawValue: error._code) {
            switch errorCode {
            case .invalidEmail:
                return "メールアドレスの形式が違います"
            case .weakPassword, .userNotFound, .wrongPassword:
                return "メールアドレスまたはパスワードが間違っています"
            case .userDisabled:
                return "このユーザーアカウントは無効化されています"
            default:
                return "ログインできません"
            }
        }
        return "エラーが発生しました"
    }
}

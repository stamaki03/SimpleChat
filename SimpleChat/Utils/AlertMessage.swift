//
//  AlertMessage.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/25.
//

import UIKit

final class AlertMessage {
    
    static let shared = AlertMessage()
    private init() {}
    
    func notificationAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "エラー", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
    
    func notificationAlertWithDismiss(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "完了", message: message, preferredStyle: UIAlertController.Style.alert)
        return alert
    }
    
    func confirmationAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "確認", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "いいえ", style: .cancel, handler: nil))
        return alert
    }
    
    func resetPasswordAlert() -> UIAlertController {
        let alert = UIAlertController(title: "パスワードをリセット", message: "メールアドレスを入力してください", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "example@co.jp"
        }
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        return alert
    }
}

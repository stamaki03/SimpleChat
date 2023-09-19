//
//  LoginViewController.swift
//  SimpleChat
//
//  Created by Sho Tamaki on 2023/09/18.
//

import UIKit
import Combine
import CombineCocoa

final class LoginViewController: UIViewController {
    
    private var cancellables: Set<AnyCancellable> = []
    @Published private var validCheck1 = false
    @Published private var validCheck2 = false
    
    let appTitleLabel = TitleLabel(frame: .zero, text: "SIMPLE CHAT")
    let idLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "ID")
    let idTextField = CustomTextField(frame: .zero, placeholder: "example@co.jp")
    let passwordLabel = CustomLabel(frame: .zero, fontSize: 20.0, text: "パスワード")
    let passwordTextField = CustomTextField(frame: .zero, placeholder: "パスワード")
    let loginSelectButton = SelectButton(frame: .zero, title: "ログイン")
    let signUpButton = ExplanationButton(frame: .zero, title: "新規登録はこちら")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // ビュー設定
        view.backgroundColor = .white
        // サブビュー設定
        idTextField.delegate = self
        passwordTextField.delegate = self
        loginSelectButton.isEnabled = false
        view.addSubview(appTitleLabel)
        view.addSubview(idLabel)
        view.addSubview(idTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loginSelectButton)
        view.addSubview(signUpButton)
        // 制約設定
        LoginViewConstraints.makeConstraints(view: view, appTitleLabel: appTitleLabel, idLabel: idLabel, idTextField: idTextField, passwordLabel: passwordLabel, passwordTextField: passwordTextField, loginSelectButton: loginSelectButton, signUpButton: signUpButton)
        // ボタンアクション設定
        loginSelectButton.addTarget(self, action: #selector(goToMainViewController(sender:)), for:.touchUpInside)
        signUpButton.addTarget(self, action: #selector(goToSignUpViewController(sender:)), for:.touchUpInside)
        // キーボード設定
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboad), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboad), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // ボタンアクション処理
    @objc internal func goToMainViewController(sender: UIButton){
        
        let mainViewController = MainViewController()
        self.navigationController?.pushViewController(mainViewController, animated: true)
        return
        
        //        let list: [User] = CoreDataRepository.array()
        //
        //        for userItems in list {
        //            if userItems.name == idTextField.text && userItems.password == passwordTextField.text {
        //                let mainViewController = MainViewController()
        //                self.navigationController?.pushViewController(mainViewController, animated: true)
        //                return
        //            }
        //        }
        
        //        let alert = UIAlertController(title: "ログインできませんでした", message: "IDまたはパスワードが正しくありません。", preferredStyle: .alert)
        //        let okAction = UIAlertAction(title: "OK", style: .default)
        //        alert.addAction(okAction)
        //        present(alert, animated: true, completion: nil)
    }
    
//    private func enableButton() {
//
//        idTextField
//            .textPublisher
//            .compactMap{ $0 }
//            .sink(receiveValue:  { text in
//                self.validCheck1 = text.isEmpty ? false : true
//            })
//            .store(in: &cancellables)
//
//        passwordTextField
//            .textPublisher
//            .compactMap{ $0 }
//            .sink(receiveValue:  { text in
//                self.validCheck2 = text.isEmpty ? false : true
//            })
//            .store(in: &cancellables)
//    }
//
//    private func aaa() {
//        [validCheck1, validCheck2]
//            .publisher
//            .allSatisfy { $0 == true }
//            .sink { bool in
//                if bool == true {
//                    self.loginSelectButton.isEnabled = true
//                    self.loginSelectButton.backgroundColor = .yellow
//                }
//            }
//            .store(in: &cancellables)
//    }
    
    
    @objc internal func goToSignUpViewController(sender: UIButton){
        let signUpViewController = SignUpViewController()
        self.navigationController?.present(signUpViewController, animated: true)
    }
    
    // キーボード処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func showKeyboad(notification: Notification) {
        let keyboadFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        guard let keyboadMinY = keyboadFrame?.minY else { return }
        let loginSelectButtonMaxY = loginSelectButton.frame.maxY
        let distance = loginSelectButtonMaxY - keyboadMinY + 20
        let transform = CGAffineTransform(translationX: 0, y: -distance)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
            self.view.transform = transform
        })
    }
    
    @objc func hideKeyboad() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, animations: {
            self.view.transform = .identity
        })
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let idIsEmpty = idTextField.text?.isEmpty ?? true
        let passwordIsEmpty = passwordTextField.text?.isEmpty ?? true

        if idIsEmpty || passwordIsEmpty {
            loginSelectButton.isEnabled = false
            loginSelectButton.backgroundColor = .lightGray
        } else {
            loginSelectButton.isEnabled = true
            loginSelectButton.backgroundColor = UIColor(named: "bg")
        }
    }
}

//
//  PasswordChangeViewController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 9/16/26.
//

import UIKit
import SnapKit
import Then
import Moya

class PasswordChangeViewController: UIViewController {
    let provider = MoyaProvider<UserAPI>(plugins: [MoyaLoggingPlugin()])
    
    let navBar = NavigationBarView(streak: "44")
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
        $0.alignment = .center
    }
    
    let titleLabel = UILabel().then {
        $0.text = "비밀번호 변경"
        $0.font = .systemFont(ofSize: 30, weight: .semibold)
    }

    let beforePasswordTextField : LabeledTextFieldView = LabeledTextFieldView(title: "비밀번호", placeholder: "비밀번호를 입력해 주세요", isPassword: true)
    let newPasswordTextField : LabeledTextFieldView = LabeledTextFieldView(title: "새 비밀번호", placeholder: "비밀번호를 입력해 주세요", isPassword: true)
    let newPasswordCheckTextField : LabeledTextFieldView = LabeledTextFieldView(title: "새 비밀번호 확인", placeholder: "비밀번호를 입력해 주세요", isPassword: true)
    let errorMessage = UILabel().then {
        $0.textColor = UIColor(named: "error")
        $0.font = .systemFont(ofSize: 15, weight: .medium)
        $0.isHidden = true
    }
    
    let changeButton = UIButton(type: .system).then {
        $0.setTitle("비밀번호 변경", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(named: "main300")
        $0.titleLabel?.font = .systemFont(ofSize: 23, weight: .semibold)
        $0.layer.cornerRadius = 10
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(changeButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        beforePasswordTextField.textField.addTarget(self, action: #selector(buttonChange), for: .editingChanged)
        newPasswordTextField.textField.addTarget(self, action: #selector(buttonChange), for: .editingChanged)
        newPasswordCheckTextField.textField.addTarget(self, action: #selector(buttonChange), for: .editingChanged)
        
        setup()
    }
    private func setup() {
        view.addSubview(navBar)
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(changeButton)
        
        stackView.addArrangedSubview(beforePasswordTextField)
        stackView.addArrangedSubview(newPasswordTextField)
        stackView.addArrangedSubview(newPasswordCheckTextField)
        stackView.addArrangedSubview(errorMessage)
        
        navBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(101)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(116)
            $0.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(59)
            $0.leading.trailing.equalToSuperview()
        }
        changeButton.snp.makeConstraints {
            $0.height.equalTo(63)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(107)
        }
    }
    
    @objc private func changeButtonTapped() {
        print("변경하기 버튼 클릭")
        let isSame = newPasswordTextField.textField.text! == newPasswordCheckTextField.textField.text!
        
        if isSame {//새 비밀번호와 비밀번호 확인이 같을 때
            provider.request(.changePassword(token: TokenManager.shared.token, oldPassword: beforePasswordTextField.textField.text!, newPassword: newPasswordTextField.textField.text!)) {
                switch $0 {
                case .success(let res):
                    guard let data = try? res.map(patchMypageInfo.self) else { return }
                    if data.statusCode == 200 {
                        TokenManager.shared.token = ""
                        UIWindow.changeRootViewController(to: LogInViewController(), animated: true)
                        
                    } else if data.statusCode == 400 {
                        self.beforePasswordTextField.textField.layer.borderWidth = 0
                        
                        self.newPasswordTextField.textField.layer.borderColor = UIColor(named: "error")?.cgColor
                        self.newPasswordTextField.textField.layer.borderWidth = 1
                        
                        self.errorMessage.text = "비밀번호는 8자-30자, 영문 대소문자, 숫자, 특수문자를 포함하여 작성새 주세요."
                        self.errorMessage.isHidden = false
                        
                    } else if data.statusCode == 401 {
                        self.newPasswordTextField.textField.layer.borderWidth = 0
                        self.newPasswordCheckTextField.textField.layer.borderWidth = 0
                        
                        self.beforePasswordTextField.textField.layer.borderColor = UIColor(named: "error")?.cgColor
                        self.beforePasswordTextField.textField.layer.borderWidth = 1
                        
                        self.errorMessage.text = "비밀번호가 일치하지 않습니다. 비밀번호를 확인해 주세요."
                        self.errorMessage.isHidden = false
                    }
                case .failure(let err):
                    print(err)
                }
            }//여기까지 연동 관련
        } else {
            beforePasswordTextField.textField.layer.borderWidth = 0
            newPasswordTextField.textField.layer.borderColor = UIColor(named: "error")?.cgColor
            newPasswordTextField.textField.layer.borderWidth = 1
            newPasswordCheckTextField.textField.layer.borderColor = UIColor(named: "error")?.cgColor
            newPasswordCheckTextField.textField.layer.borderWidth = 1
            errorMessage.text = "비밀번호가 일치하지 않습니다."
            errorMessage.isHidden = false
        }//다를 때..
    }
    @objc private func buttonChange() {
        let isEmpty = (beforePasswordTextField.textField.text?.isEmpty ?? true) || (newPasswordTextField.textField.text?.isEmpty ?? true) || (newPasswordCheckTextField.textField.text?.isEmpty ?? true)
        
        if !isEmpty {
            changeButton.isEnabled = true
            changeButton.backgroundColor = UIColor(named: "main600")
        } else {
            changeButton.isEnabled = false
            changeButton.backgroundColor = UIColor(named: "main300")
        }
    }
}

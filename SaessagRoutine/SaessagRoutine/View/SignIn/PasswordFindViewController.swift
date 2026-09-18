//
//  PasswordChangeViewController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 9/9/26.
//

import SnapKit
import Then
import Moya
import UIKit

final class PasswordFindViewController: UIViewController {
    let provider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggingPlugin()])
    let scrollView = UIScrollView()
    
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
        $0.alignment = .fill
    }
    let emailStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .trailing
    }
    let codeStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .trailing
    }
    
    let titleText = UILabel().then {
        $0.text = "비밀번호 찾기"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 30, weight: .semibold)
    }
    
    let emailTextField : LabeledTextFieldView = LabeledTextFieldView(title: "이메일", placeholder: "이메일을 입력해 주세요.", isPassword: false)
    let verificationCodeTextField : LabeledTextFieldView = LabeledTextFieldView(title: "인증번호", placeholder: "인증번호를 입력해 주세요.", isPassword: false)
    let passwordTextField : LabeledTextFieldView = LabeledTextFieldView(title: "새 비밀번호", placeholder: "비밀번호를 입력해 주세요.", isPassword: true)
    let checkPasswordTextField : LabeledTextFieldView = LabeledTextFieldView(title: "새 비밀번호 확인", placeholder: "비밀번호를 입력해 주세요.", isPassword: true)
    
    let emailSendButton = UIButton(type: .system).then {
        $0.setTitle("인증 번호 전송", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        $0.tintColor = UIColor(named: "main800")
        $0.backgroundColor = UIColor(named: "gray200")
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
    }//이메일 발송 버튼
    let codeCheckButton = UIButton(type: .system).then {
        $0.setTitle("인증 번호 확인", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        $0.tintColor = UIColor(named: "main800")
        $0.backgroundColor = UIColor(named: "gray200")
        $0.layer.cornerRadius = 20
        $0.addTarget(self, action: #selector(checkCode), for: .touchUpInside)
    }//인증번호 확인 버튼
    
    let changeButton = UIButton(type: .system).then {
        $0.setTitle("비밀번호 변경하기 ", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 25, weight: .semibold)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(named: "main300")
        $0.layer.cornerRadius = 10
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
    }
    let errorMessage = UILabel().then {
        $0.textColor = UIColor(named: "error")
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setup()
        
        emailTextField.textField.addTarget(self, action: #selector(buttonChange), for: .editingChanged)
        passwordTextField.textField.addTarget(self, action: #selector(buttonChange), for: .editingChanged)
        checkPasswordTextField.textField.addTarget(self, action: #selector(buttonChange), for: .editingChanged)
        verificationCodeTextField.textField.addTarget(self, action: #selector(buttonChange), for: .editingChanged)
    }
    private func setup() {
        view.addSubview(scrollView)
            
        scrollView.addSubview(titleText)
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(emailStackView)
        stackView.addArrangedSubview(codeStackView)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(checkPasswordTextField)
        stackView.addArrangedSubview(errorMessage)
        stackView.addArrangedSubview(changeButton)
        
        emailStackView.addArrangedSubview(emailTextField)
        emailStackView.addArrangedSubview(emailSendButton)
        
        codeStackView.addArrangedSubview(verificationCodeTextField)
        codeStackView.addArrangedSubview(codeCheckButton)
            
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    
        titleText.snp.makeConstraints {
            $0.top.equalToSuperview().inset(116)
            $0.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleText.snp.bottom).offset(59)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(32)
            $0.width.equalTo(scrollView.frameLayoutGuide).inset(24)
        }
            
        emailSendButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(134)
        }
        codeCheckButton.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(134)
        }
        
        changeButton.snp.makeConstraints {
            $0.height.equalTo(54)
        }
    }
    
    @objc private func sendEmail() {
        print("이메일 전송버튼 클릭")
        if emailTextField.textField.text?.isEmpty == true {//텍스트필드 비어있을 때
            errorMessage.text = "이메일 주소를 입력해주세요"
            errorMessage.isHidden = false
            emailTextField.textField.layer.borderWidth = 1
            emailTextField.textField.layer.borderColor = UIColor(named: "error")?.cgColor
        } else {//채워져 있을 때
            provider.request(.checkEmail(email: (emailTextField.textField.text)!)) {//리퀘스트 보냄
                switch $0 {
                case .success(let res)://통신 성공 시
                    guard let data = try? res.map(authResponse.self) else { print("디코딩 실패"); return }
                    if data.statusCode == 200 {//성공시
                        self.emailSendButton.backgroundColor = UIColor(named: "main300")
                        self.emailTextField.textField.layer.borderWidth = 0
                        self.errorMessage.isHidden = true
                    } else if data.statusCode == 404 {//사용자 못 찾았을 때
                        self.errorMessage.text = "사용자를 찾을 수 없습니다. 이메일 주소를 확인해 주세요."
                        self.errorMessage.isHidden = false
                        self.emailTextField.textField.layer.borderWidth = 1
                        self.emailTextField.textField.layer.borderColor = UIColor(named: "error")?.cgColor
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }//인증번호 발송버튼 클릭 시
    @objc private func checkCode() {
        print("인증번호 확인 버튼 클릭")
        if verificationCodeTextField.textField.text?.isEmpty == true {//텍스트필드 비어있을 때
            errorMessage.text = "인증 코드를 입력해주세요"
            errorMessage.isHidden = false
            verificationCodeTextField.textField.layer.borderWidth = 1
            verificationCodeTextField.textField.layer.borderColor = UIColor(named: "error")?.cgColor
        } else {//채워져 있을 때
            provider.request(.checkVerifyCode(email: emailTextField.textField.text!, code: verificationCodeTextField.textField.text!)) {
                switch $0 {
                    case .success(let res):
                        guard let data = try? res.map(authResponse.self) else { print("디코딩 실패"); return }
                        if data.statusCode == 200 {
                            self.codeCheckButton.backgroundColor = UIColor(named: "main300")
                            self.verificationCodeTextField.textField.layer.borderWidth = 0
                            self.errorMessage.isHidden = true
                        }
                        else if data.statusCode == 400 {
                            self.errorMessage.text = data.message
                            self.errorMessage.isHidden = false
                        }
                case .failure(let err):
                    print(err)
                }
            }
        }
    }//인증 번호 확인 버튼 클릭 시
    @objc private func changePassword() {
        print("비밀번호 변경 버튼 클릭")
        let isPasswordSame = passwordTextField.textField.text == checkPasswordTextField.textField.text
        if isPasswordSame {//비밀번호 일치 시
            provider.request(.changePassword(email: emailTextField.textField.text!, newPassword: passwordTextField.textField.text!)) {
                switch $0 {
                case .success(let res):
                    guard let data = try? res.map(authResponse.self) else { print("디코딩 실패"); return }
                    if data.statusCode == 200 {
                        UIWindow.changeRootViewController(to: LogInViewController(), animated: true)
                        self.navigationController?.popViewController(animated: true)
                    } else if data.statusCode == 400 {
                        self.errorMessage.text = data.message
                        self.errorMessage.isHidden = false
                    }
                case .failure(let err):
                    print(err)
                }
            }
        } else {
            errorMessage.text = "비밀번호가 일치하지 않습니다"
            errorMessage.isHidden = false
            
            passwordTextField.textField.layer.borderWidth = 1
            passwordTextField.textField.layer.borderColor = UIColor(named: "error")?.cgColor
            
            checkPasswordTextField.textField.layer.borderWidth = 1
            checkPasswordTextField.textField.layer.borderColor = UIColor(named: "error")?.cgColor
        }
    }//비밀번호 변경 버튼 클릭 시
    
    @objc func buttonChange() {
        
        let isEmpty = (passwordTextField.textField.text?.isEmpty ?? true) || (checkPasswordTextField.textField.text?.isEmpty ?? true) || (verificationCodeTextField.textField.text?.isEmpty ?? true) || (emailTextField.textField.text?.isEmpty ?? true)
        
        if !isEmpty {//다 채워져있을 때
            changeButton.backgroundColor = UIColor(named: "main600")
            changeButton.isEnabled = true
        } else {
            changeButton.backgroundColor = UIColor(named: "main300")
            changeButton.isEnabled = false
        }
    }
}

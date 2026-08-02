//
//  ViewController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 7/30/26.
//

import UIKit
import SnapKit
import Then
import Moya

class SignUpViewController: UIViewController {
    let titleLabel = UILabel().then {
        $0.text = "계정 만들기"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 30, weight: .semibold)
    }
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 19
    }
    
    let idTextField = LabeledTextFieldView(title: "아이디", placeholder: "앱에서 불릴 이름", isPassword: false)
    let emailTextField = LabeledTextFieldView(title: "이메일", placeholder: "이메일을 입력해 주세요", isPassword: false)
    let passwordTextField = LabeledTextFieldView(title: "비밀번호", placeholder: "비밀번호를 입력해 주세요", isPassword: true)
    let passwordCheckTextField = LabeledTextFieldView(title: "비밀번호 확인", placeholder: "비밀번호를 확인해주세요", isPassword: true)
    let errorMessagePassword = UILabel().then {
        $0.text = "비밀번호가 일치하지 않습니다."
        $0.textColor = UIColor(named: "error")
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.isHidden = true
    }
    let errorMessageNoInput = UILabel().then {
        $0.text = "모두 입력되지 않았습니다"
        $0.textColor = UIColor(named: "error")
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.isHidden = true
    }
    
    let signUpButton = UIButton(type: .system).then {
        $0.setTitle("가입하고 시작하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.titleLabel?.font = .systemFont(ofSize: 25, weight: .semibold)
        $0.addTarget(self, action: #selector(passwordCheck), for: .touchUpInside)
    }
    let toLoginText = UILabel().then {
        $0.text = "이미 계정이 있으신가요?"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 15, weight: .semibold)
    }
    let toLoginButton = UIButton(type: .system).then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(UIColor(named: "main700"), for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        $0.addTarget(self, action: #selector(toLogin), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        buttonChange()
        //buttonChange 함수 초기 호출 해서 기본값 잡기
        
        idTextField.textField.addTarget(self, action: #selector(buttonChange), for: .editingChanged)
        emailTextField.textField.addTarget(self, action: #selector(buttonChange), for: .editingChanged)
        passwordTextField.textField.addTarget(self, action: #selector(buttonChange), for: .editingChanged)
        passwordCheckTextField.textField.addTarget(self, action: #selector(buttonChange), for: .editingChanged)
        //입력할 때마다 버튼 색, 활성화 여부 바꾸는 함수 호출

    }
    
    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(signUpButton)
        view.addSubview(toLoginText)
        view.addSubview(toLoginButton)
        
        stackView.addArrangedSubview(idTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(passwordCheckTextField)
        stackView.addArrangedSubview(errorMessagePassword)
        //스택뷰에 추가
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(98)
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(79)
            $0.centerX.width.equalToSuperview().inset(24)
        }
        signUpButton.snp.makeConstraints {
            $0.trailing.leading.equalTo(stackView)
            $0.height.equalTo(63)
            $0.bottom.equalToSuperview().inset(68)
        }
        toLoginText.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(103)
            $0.bottom.equalToSuperview().inset(31)
        }
        toLoginButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(103)
            $0.centerY.equalTo(toLoginText)
        }
    }
    @objc private func buttonChange() {
        let isEmailEmpty = emailTextField.textField.text?.isEmpty ?? true
        let isPasswordEmpty = passwordTextField.textField.text?.isEmpty ?? true
        let isPasswordCheckEmpty = passwordCheckTextField.textField.text?.isEmpty ?? true
        let isIdEmpty = idTextField.textField.text?.isEmpty ?? true
        //비었는지 안비었는지 확인
        
        if isEmailEmpty || isPasswordEmpty || isPasswordCheckEmpty || isIdEmpty{
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor(named: "main300")
            //하나라도 입력이 안됐을 때
        } else {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor(named: "main600")
            //전부 다 입력이 됐을 때
        }
    }
    @objc private func passwordCheck() {
        let password = passwordTextField.textField.text
        let passwordCheck = passwordCheckTextField.textField.text
        if password == passwordCheck {
            toLogin()
        } else {
            errorMessagePassword.isHidden = false
        }
        return
    }
    @objc private func toLogin() {
        navigationController?.popViewController(animated: false)
    }
}


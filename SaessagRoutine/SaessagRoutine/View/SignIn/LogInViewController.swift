//
//  LogInViewController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 7/31/26.
//

import UIKit
import SnapKit
import Then
import Moya

class LogInViewController: UIViewController {
    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 19
    }
    let titleText = UILabel().then {
        $0.text = "로그인"
        $0.font = .systemFont(ofSize: 37, weight: .semibold)
        $0.textColor = .black
    }
    let emailTextField : LabeledTextFieldView = LabeledTextFieldView(title: "이메일 주소", placeholder: "이메일을 입력해 주세요.", isPassword: false)
    let passwordTextField : LabeledTextFieldView = LabeledTextFieldView(title: "비밀번호", placeholder: "비밀번호를 입력해 주세요.", isPassword: true)
    let loginButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.setTitle("로그인하기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 25, weight: .semibold)
        $0.addTarget(self, action: #selector(logInToHome), for: .touchUpInside)
    }
    let signUpText = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.text = "아직 계정이 없으시다면?"
        $0.textColor = UIColor(named: "gray600")
    }
    let signUpButton = UIButton(type: .system).then {
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        $0.setTitleColor(UIColor(named: "gray600"), for: .normal)
        $0.addTarget(self, action: #selector(logInToSignUp), for: .touchUpInside)
        
        let attributedString = NSMutableAttributedString(string: "가입하기")
        
        attributedString.addAttribute(.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.isEnabled = true
    }
    let errorMessege = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = UIColor(named: "error")
        $0.text = "이메일 주소와 비밀번호를 확인해 주세요."
        $0.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        
        if emailTextField.textField.text?.isEmpty ?? true || passwordTextField.textField.text?.isEmpty ?? true {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor(named: "main300")
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor(named: "main600")
        }
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(titleText)
        view.addSubview(stackView)
        view.addSubview(loginButton)
        view.addSubview(signUpText)
        view.addSubview(signUpButton)
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(errorMessege)
        
        titleText.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(181)
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleText.snp.bottom).offset(110)
            $0.centerX.width.equalToSuperview().inset(24)
        }
        signUpText.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(155)
            $0.bottom.equalTo(loginButton.snp.top).offset(-19)
            $0.height.equalTo(16)
        }
        signUpButton.snp.makeConstraints {
            $0.centerY.equalTo(signUpText)
            $0.leading.equalTo(signUpText.snp.trailing)
            $0.height.equalTo(signUpText)
        }
        loginButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(63)
        }
    }
    @objc func logInToSignUp() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: false)
    }
    @objc func logInToHome() {
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: false)
    }
}

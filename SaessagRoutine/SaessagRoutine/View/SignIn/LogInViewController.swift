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

class LogInViewController: UIViewController, UIGestureRecognizerDelegate {
    let provider = MoyaProvider<AuthAPI>(plugins:[MoyaLoggingPlugin()])
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
    let loginButton = UIButton(type: .system).then {
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        $0.setTitle("로그인하기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 25, weight: .semibold)
        $0.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
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
        
        let attributedString = NSMutableAttributedString(string: "회원가입")
        
        attributedString.addAttribute(.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        $0.setAttributedTitle(attributedString, for: .normal)
    }
    let errorMessage = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = UIColor(named: "error")
        $0.isHidden = true
    }
    let changePasswordButton = UIButton(type: .system).then {
        $0.setTitleColor(UIColor(named: "gray600"), for: .normal)
        
        let attributedString = NSMutableAttributedString(string: "비밀번호 찾기")
        
        attributedString.addAttribute(.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.addTarget(self, action: #selector(toPasswordChange), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        logInButtonChange()
        emailTextField.textField.addTarget(self, action: #selector(logInButtonChange), for: .editingChanged)
        passwordTextField.textField.addTarget(self, action: #selector(logInButtonChange), for: .editingChanged)
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        
        view.addSubview(titleText)
        view.addSubview(stackView)
        view.addSubview(loginButton)
        view.addSubview(signUpText)
        view.addSubview(signUpButton)
        view.addSubview(changePasswordButton)
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(errorMessage)
        
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
        changePasswordButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(passwordTextField.snp.bottom).offset(6)
        }
    }
    @objc func logInToSignUp() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: false)
    }
    @objc func logInButtonTapped() {
        provider.request(.login(email: emailTextField.textField.text!, password: passwordTextField.textField.text!)) {
            switch $0 {
            case .success(let res):
                guard let data = try? res.map(loginResponse.self) else { print("디코딩 실패"); return }
                if data.statusCode == 200 {
                    print("로그인 성공")
                    TokenManager.shared.token = data.accessToken!
                    
                    let homeVC = RootTabBarController()
                    self.navigationController?.pushViewController(homeVC, animated: false)
                    UIWindow.changeRootViewController(to: homeVC, animated: true)
                } else if data.statusCode == 401 {
                    print("비밀번호 틀림")
                    
                    DispatchQueue.main.async {
                        self.errorMessage.text = "비밀번호를 다시 확인해 주세요."
                        self.errorMessage.isHidden = false
                        
                        self.passwordTextField.textField.layer.borderColor = UIColor(named: "error")?.cgColor
                        self.passwordTextField.textField.layer.borderWidth = 1
                        self.emailTextField.textField.layer.borderWidth = 0
                    }
                } else if data.statusCode == 400 {
                    DispatchQueue.main.async {
                        self.errorMessage.text = "이메일과 비밀번호를 다시 확인해 주세요."
                        self.errorMessage.isHidden = false
                        
                        self.emailTextField.textField.layer.borderColor = UIColor(named: "error")?.cgColor
                        self.emailTextField.textField.layer.borderWidth = 1
                    }
                    print("계정 없음")
                } else {
                    print(data.statusCode)
                }
                
            case .failure(_):
                print("API 연동 실패")
            }
        }
    }//로그인 버튼 클릭시

    @objc private func logInButtonChange() {
        let isEmailEmpty = emailTextField.textField.text?.isEmpty ?? true
        let isPasswordEmpty = passwordTextField.textField.text?.isEmpty ?? true
        
        if isEmailEmpty || isPasswordEmpty {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor(named: "main300")
        } else {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor(named: "main600")
        }
    }
    @objc private func toPasswordChange() {
        let passwordChangeVC = PasswordChangeViewController()
        navigationController?.pushViewController(passwordChangeVC, animated: true)
    }
}
extension LogInViewController {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return (navigationController?.viewControllers.count ?? 0) > 1
    }
}

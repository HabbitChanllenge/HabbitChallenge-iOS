//
//  MyPageEditViewController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/21/26.
//

import UIKit
import SnapKit
import Then
import Moya

class MyPageEditViewController: UIViewController {
    let provider = MoyaProvider<UserAPI>(plugins:[MoyaLoggingPlugin()])
    let deleteProvider = MoyaProvider<AuthAPI>(plugins: [MoyaLoggingPlugin()])
    
    let navBar = NavigationBarView(streak: "31")
    
    let profileImg = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "profileImg")
    }
    let textFiledStack = MyPageTextField(canEdit: true)
    let editButton = UIButton(type: .system).then {
        $0.setTitle("수정 완료하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(named: "main600")
        $0.layer.cornerRadius = 10
        $0.titleLabel?.font = .systemFont(ofSize: 25, weight: .semibold)
        $0.addTarget(self, action: #selector(editFinishButtonTapped), for: .touchUpInside)
    }//수정 완료 버튼. 클릭 시 메인 마이페이지로 돌아감
    let notAllFilled = UILabel().then {
        $0.text = "형식에 맞게 입력해 주세요"
        $0.textColor = UIColor(named: "error")
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.isHidden = true
    }//에러메세지. 모두 입력되지 않았을 때 표시
    let accountDeleteButton = UIButton(type: .system).then {
        $0.setTitle("회원 탈퇴", for: .normal)
        $0.setTitleColor(UIColor(named: "gray600"), for: .normal)
        $0.backgroundColor = .clear
        $0.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
    }//회원 탈퇴버튼. 클릭시 배경 딤처리 및 탈퇴 팝업 표시
    let changePasswordButton = UIButton(type: .system).then {
        let attributedText = NSMutableAttributedString(string: "비밀번호 변경")
        attributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: 7))
        $0.setAttributedTitle(attributedText, for: .normal)
        $0.tintColor = UIColor(named: "gray600")
        $0.addTarget(self, action: #selector(changePasswordButtonTapped), for: .touchUpInside)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        provider.request(.getUserInfo(token: TokenManager.shared.token)) {
            switch $0 {
            case .success(let res):
                guard let data = try? res.map(getMypageInfo.self) else { print("디코딩 실패"); return }
                if data.statusCode == 200 {
                    self.textFiledStack.setInfo(id: data.name, email: data.email)
                }
            case .failure(let err):
                print(err)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(navBar)
        view.addSubview(profileImg)
        view.addSubview(textFiledStack)
        view.addSubview(notAllFilled)
        view.addSubview(editButton)
        view.addSubview(accountDeleteButton)
        view.addSubview(changePasswordButton)
        
        navBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(101)
        }
        profileImg.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(27)
            $0.height.width.equalTo(173)
            $0.centerX.equalToSuperview()
        }
        
        textFiledStack.snp.makeConstraints {
            $0.top.equalTo(profileImg.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        notAllFilled.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(editButton.snp.top).offset(-4)
        }
        
        editButton.snp.makeConstraints {
            $0.height.equalTo(63)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(38)
        }
        accountDeleteButton.snp.makeConstraints {
            $0.top.equalTo(editButton.snp.bottom).offset(14)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(15)
            $0.width.equalTo(60)
        }
        changePasswordButton.snp.makeConstraints {
            $0.top.equalTo(textFiledStack.snp.bottom).offset(5)
            $0.trailing.equalToSuperview().inset(24)
        }
    }
    
    @objc private func editFinishButtonTapped() {
        guard let emailT = textFiledStack.email.textField.text,
            let idT = textFiledStack.id.textField.text,
            !emailT.isEmpty, !idT.isEmpty else {
            notAllFilled.isHidden = false
            return
        }
        //모두 다 채워져 있을 시
        provider.request(.patchUserInfo(token: TokenManager.shared.token, userId: idT, email: emailT)) {
            switch $0 {
            case .success(let res):
                guard let data = try? res.map(patchMypageInfo.self) else { print("디코딩 실패"); return }
                if data.statusCode == 200 {
                    TokenManager.shared.token = ""
                    UIWindow.changeRootViewController(to: LogInViewController(), animated: true)
                }
            case .failure(let err):
                print(err)
            }
        }
        
        
    }//수정 완료 버튼 클릭시
    @objc private func deleteAccountButtonTapped() {
        let alertView = UIAlertController(title: "새싹루틴 회원을 탈퇴하시겠습니까?", message: "", preferredStyle: .alert).then {
            $0.addTextField {
                $0.placeholder = "비밀번호를 작성해 주세요."
                $0.textContentType = .password
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "탈퇴", style: .destructive, handler: { _ in
            let password = alertView.textFields?.first?.text ?? ""
            
            self.deleteProvider.request(.resign(token: TokenManager.shared.token, password: password)) {
                switch $0 {
                case .success(let res):
                    guard let data = try? res.map(authResponse.self) else { return }
                    if data.statusCode == 200 {
                        TokenManager.shared.token = ""
                        UIWindow.changeRootViewController(to: LogInViewController(), animated: true)
                    } else if data.statusCode == 401 {
                        let alert = UIAlertController(title: "비밀번호를 확인해 주세요.", message: "", preferredStyle: .alert)
                        alert.addAction(.init(title: "확인", style: .cancel))
                        self.present(alert, animated: false)
                    }
                    
                case .failure(let err):
                    print(err)
                }
            }
        })
        alertView.addAction(cancelAction)
        alertView.addAction(confirmAction)
        
        present(alertView, animated: false)
    }//회원 탈퇴 버튼 클릭 시
    @objc private func changePasswordButtonTapped() {
        print("비밀번호 변경 버튼 클릭")
        navigationController?.pushViewController(PasswordChangeViewController(), animated: true)
    }
}

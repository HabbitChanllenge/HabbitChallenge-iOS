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
    let userInfo : [user] = UserData.userInformation
    
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
    
    let dimmedView = UIView().then {
        $0.backgroundColor = .black.withAlphaComponent(0.4)
        $0.isHidden = true
    }//배경 어둡게. 평소엔 안보임
    lazy var alertView : UIView = {//그냥 let으로 하면 버튼 연동 안되서 lazy var 사용
        let alertView = UIView().then {
            $0.backgroundColor = UIColor(named: "gray300")
            $0.layer.cornerRadius = 10
        }//최종 뷰
        let titleLabel = UILabel().then {
            $0.text = "탈퇴 하시려면 비밀번호 확인을 해주세요."
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 18, weight: .regular)
            $0.numberOfLines = 0
        }
        
        let passwordCheckText = UILabel().then {
            $0.text = "비밀번호 확인"
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 15, weight: .regular)
        }
        let cancelButton = UIButton(type: .system).then {
            $0.setTitle("취소", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = UIColor(named: "gray500")
            $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            $0.layer.cornerRadius = 16
            $0.addTarget(self, action: #selector(dismissAlphaDarkView), for: .touchUpInside)
        }
        let deleteButton = UIButton(type: .system).then {
            $0.setTitle("확인", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = UIColor(named: "gray600")
            $0.layer.cornerRadius = 16
            $0.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
        }
        
        alertView.addSubview(titleLabel)
        alertView.addSubview(passwordCheckText)
        alertView.addSubview(passwordCheckTextField)
        alertView.addSubview(cancelButton)
        alertView.addSubview(deleteButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        passwordCheckText.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        passwordCheckTextField.snp.makeConstraints {
            $0.height.equalTo(47)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.top.equalTo(passwordCheckText.snp.bottom).offset(7)
        }
        cancelButton.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.width.equalTo(81)
            $0.top.equalTo(passwordCheckTextField.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(48)
        }
        deleteButton.snp.makeConstraints {
            $0.height.width.centerY.equalTo(cancelButton)
            $0.trailing.equalToSuperview().inset(48)
        }
        
    
        return alertView
    }()//탈퇴 팝업. 탈퇴 버튼 클릭 시 표시
    let passwordCheckTextField = UITextField().then {
        $0.placeholder = "비밀번호를 입력해주세요"
        $0.isSecureTextEntry = true
        $0.backgroundColor = .white
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        $0.leftView = leftPaddingView
        $0.leftViewMode = .always
        $0.layer.cornerRadius = 10
    }//다른 메서드에서 얘 입력값 확인해야 해서 빼둠
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView.isHidden = true//탈퇴 팝업 숨김처리
        
        setupView()
    }
    
    private func setupView() {
        view.addSubview(navBar)
        view.addSubview(profileImg)
        view.addSubview(textFiledStack)
        view.addSubview(notAllFilled)
        view.addSubview(editButton)
        view.addSubview(accountDeleteButton)
        
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
            $0.top.equalTo(textFiledStack.snp.bottom).offset(3)
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
    }
    
    @objc private func editFinishButtonTapped() {
        let emailT = textFiledStack.email.textField.text
        let passwordT = textFiledStack.password.textField.text
        let idT = textFiledStack.id.textField.text
        
        if emailT == "" || passwordT == "" || idT == "" {//하나라도 비어있을 시 에러메세지 표시
            notAllFilled.isHidden = false
        } else {//모두 다 채워져 있을 시
            if let rootVC = self .navigationController?.viewControllers.first(where: { $0 is MyPageViewContoller }) as? MyPageViewContoller {
                rootVC.editSucsessMessage.isHidden = false//수정 완료 메세지 표시
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    rootVC.editSucsessMessage.isHidden = true
                }//1.2초 후에 수정 완료 메세지 숨기기
            }
            self.navigationController?.popViewController(animated: false)//화면전환
        }//모두 채워져 있는지 확인 로직
    }//수정 완료 버튼 클릭시
    @objc private func deleteAccountButtonTapped() {
        dimmedView.isHidden = false
        alertView.isHidden = false
        
        //여기부터 레이아웃 잡기
        guard let tabBarContainerView = self.tabBarController?.view else { return }
        tabBarContainerView.addSubview(dimmedView)
        dimmedView.addSubview(alertView)
        
        dimmedView.addSubview(alertView)
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        alertView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(215)
            $0.width.equalTo(280)
        }
    }//회원 탈퇴 버튼 클릭 시
    @objc private func dismissAlphaDarkView() {
        print("취소버튼 클릭")
        alertView.isHidden = true
        dimmedView.isHidden = true
        //배경 다시 밝게, 팝업창 숨김
        dimmedView.removeFromSuperview()//매 탈퇴 버튼 클릭 시 뷰에 추가되면 메모리가 아파서 취소버튼 클릭 시 레이아웃 지워줌
        alertView.removeFromSuperview()//위와 같음
    }//탈퇴 팝업에 취소 버튼 클릭 시 실행
    @objc private func deleteAccount() {
        print("확인버튼 클릭")
        if self.passwordCheckTextField.text == userInfo[0].password {
            UIWindow.changeRootViewController(to: LogInViewController(), animated: false)//루트뷰 로그인으로 바꾸기
        } else {
            print(self.passwordCheckTextField.text)
            print("탈퇴 실패-비번 다름")
            passwordCheckTextField.layer.borderColor = UIColor(named: "error")?.cgColor
            passwordCheckTextField.layer.borderWidth = 1
        }
    }//탈퇴 팝업 확인 버튼 클릭 시 실행
}

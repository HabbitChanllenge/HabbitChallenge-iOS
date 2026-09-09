//
//  MyPageTextField.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/21/26.
//

import UIKit
import SnapKit
import Then
import Moya

final class MyPageTextField: UIView {
    var userInfo = MoyaProvider<UserAPI>(plugins: [MoyaLoggingPlugin()])
    
    let stack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 19
    }
    
    let email : LabeledTextFieldView = LabeledTextFieldView(title: "이메일", placeholder: "이메일을 입력해 주세요", isPassword: false)
    let id : LabeledTextFieldView = LabeledTextFieldView(title: "아이디", placeholder: "아이디를 입력해 주세요", isPassword: false)
    
    init(canEdit: Bool) {
        super.init(frame: .zero)
        if !canEdit {
            email.textField.isEnabled = false
            id.textField.isEnabled = false
        }
        setupLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubview(stack)
        
        stack.addArrangedSubview(email)
        stack.addArrangedSubview(id)
        
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    func setInfo(id : String, email : String) {
        self.email.textField.text = email
        self.id.textField.text = id
    }
}

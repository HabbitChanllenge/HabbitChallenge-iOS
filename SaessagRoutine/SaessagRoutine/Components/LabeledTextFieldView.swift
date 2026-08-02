//
//  labeledTextFieldView.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 7/31/26.
//

import UIKit
import SnapKit
import Then
final class LabeledTextFieldView: UIView {
    let titleText = UILabel().then {
        $0.font = .systemFont(ofSize: 25, weight: .semibold)
        $0.textColor = .black
    }
    let textField = UITextField().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = UIColor(named: "gray200")
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        $0.leftView = leftPaddingView
        $0.leftViewMode = .always
    }
    let passwordSecureButton = UIButton(type: .system).then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "eye.slash")
        config.baseForegroundColor = UIColor(named: "gray600")
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15)
        $0.configuration = config
    }
    
    init(title: String, placeholder: String, isPassword: Bool) {
        super.init(frame: .zero)
        titleText.text = title
        setup()
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor(named: "gray600")])
        passwordSecureButton.addTarget(self, action: #selector(setSecure), for: .touchUpInside)
        textField.isSecureTextEntry = isPassword
        if !isPassword {
            passwordSecureButton.isHidden = true
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubview(titleText)
        self.addSubview(textField)
        
        textField.rightView = passwordSecureButton
        textField.rightViewMode = .always
        
        titleText.snp.makeConstraints {
            $0.width.top.equalToSuperview()
            $0.height.equalTo(30)
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(titleText.snp.bottom).offset(19)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    @objc private func setSecure() {
        if textField.isSecureTextEntry {
            textField.isSecureTextEntry = false
            passwordSecureButton.setImage(UIImage(systemName: "eye"), for: .normal)
        }
        else {
            textField.isSecureTextEntry = true
            passwordSecureButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }
}

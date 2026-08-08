//
//  checkBoxView.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/8/26.
//

import UIKit
import SnapKit
import Then
final class CheckBoxView: UIView {
    let square = UIButton().then {
        $0.layer.cornerRadius = 5
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "main900")?.cgColor
        $0.addTarget(self, action: #selector(checkBoxTapped), for: .touchUpInside)
    }
    let checkmark = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark")
        $0.tintColor = UIColor(named: "main800")
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setLayout() {
        self.addSubview(square)
        self.addSubview(checkmark)
        square.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(25)
        }
        checkmark.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(25)
        }
    }
    @objc private func checkBoxTapped() {
        checkmark.isHidden = false
    }
}

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
        $0.text = "회원가입"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 30, weight: .semibold)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}


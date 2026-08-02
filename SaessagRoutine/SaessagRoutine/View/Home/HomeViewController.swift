//
//  HomeViewController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 7/31/26.
//

import UIKit
import SnapKit
import Then
import Moya

class HomeViewController: UIViewController {
    let titleText = UILabel().then {
        $0.text = "홈"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleText)
        titleText.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}


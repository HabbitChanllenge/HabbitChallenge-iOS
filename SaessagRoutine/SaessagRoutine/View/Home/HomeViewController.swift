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
    let navBar = NavigationBarView(streak: "31")
    let titleText = UILabel().then {
        $0.text = "홈"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(titleText)
        view.addSubview(navBar)
        
        navBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(108)
        }
        titleText.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }
}


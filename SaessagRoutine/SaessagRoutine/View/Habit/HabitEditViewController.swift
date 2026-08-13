//
//  HabitEditViewController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/4/26.
//

import UIKit
import SnapKit
import Then
import Moya

class HabitEditViewController: UIViewController {
    let titleText = UILabel().then {
        $0.text = "습관 수정"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .black
    }
    let topBar = NavigationBarView(streak: "31")
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setLayout()
    }
    private func setLayout() {
        view.addSubview(titleText)
        view.addSubview(topBar)
        
        titleText.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        topBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(101)
        }
    }
}

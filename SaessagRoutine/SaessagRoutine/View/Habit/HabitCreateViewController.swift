//
//  HabitCreateViewController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/13/26.
//

import UIKit
import SnapKit
import Then
import Moya

class HabitCreateViewController: UIViewController {
    let topBar : NavigationBarView = NavigationBarView(streak: "108")
    let text = UILabel().then {
        $0.text = "습관 생성"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 20)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(topBar)
        view.addSubview(text)
        topBar.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
            $0.height.equalTo(101)
        }
        text.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

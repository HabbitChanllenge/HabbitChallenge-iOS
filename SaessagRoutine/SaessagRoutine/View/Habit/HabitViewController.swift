//
//  HabbitMainViewController.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 8/2/26.
//

import UIKit
import SnapKit
import Then
import Moya

class HabitViewController: UIViewController {
    let topBar = NavigationBarView(streak: "20")
    let titleText = UILabel().then {
        $0.text = "Habit"
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    let createButton = UIButton(type: .system).then {
        $0.imageView?.contentMode = .scaleAspectFit
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.tintColor = UIColor(named: "main800")
        $0.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setLayout()
    }
    private func setLayout() {
        view.addSubview(titleText)
        view.addSubview(topBar)
        view.addSubview(createButton)
        
        titleText.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        topBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(101)
        }
        createButton.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(25)
        }
    }//레이아웃 잡기
    @objc private func plusTapped() {
        navigationController?.pushViewController(HabitCreateViewController(), animated: false)
    }//생성 버튼 클릭 시 습관 생성 화면으로 이동
}


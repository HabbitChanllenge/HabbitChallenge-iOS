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
    var habitList: [Habit] = MockHabitCard.habit
    let topBar = NavigationBarView(streak: "20")
    let createButton = UIButton(type: .system).then {
        $0.imageView?.contentMode = .scaleAspectFit
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.tintColor = UIColor(named: "main800")
        $0.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
    }
    let cardStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setLayout()
        
        for i in 0..<habitList.count {
            createCard(id: i)
        }
    }
    private func setLayout() {
        view.addSubview(topBar)
        view.addSubview(createButton)
        view.addSubview(cardStackView)
    
        topBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(101)
        }
        createButton.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom)
            $0.trailing.equalToSuperview().inset(24)
            $0.height.width.equalTo(25)
        }
        cardStackView.snp.makeConstraints {
            $0.top.equalTo(createButton.snp.bottom).offset(9)
            $0.leading.trailing.equalToSuperview()
        }
    }//레이아웃 잡기
    @objc private func plusTapped() {
        navigationController?.pushViewController(HabitCreateViewController(), animated: false)
    }//생성 버튼 클릭 시 습관 생성 화면으로 이동
    
    private func createCard(id : Int) {
        let card = HabitCardView(
            titleText: habitList[id].name,
            days: habitList[id].streak,
            times: habitList[id].totalRepeat,
            didTimes: habitList[id].didRepeat,
            category: habitList[id].category,
            cycle: habitList[id].periodType,
            day: habitList[id].dayOfWeek
        )
        cardStackView.addArrangedSubview(card)
    }
}


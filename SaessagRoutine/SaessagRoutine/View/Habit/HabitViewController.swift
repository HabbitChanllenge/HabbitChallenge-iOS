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
    let provider = MoyaProvider<HabitAPI>(plugins: [MoyaLoggingPlugin()])
    
    var habitList: [Habit] = MockHabitCard.habit
    
    let topBar = NavigationBarView(streak: String(StreakManager.shared.allStreak))
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
    let scrollView = UIScrollView()
    var habitProgressCard : HabitProgressCardView = HabitProgressCardView()
    
    let noHabitCard : UIView = {
        let card = UIView().then {
            $0.backgroundColor = UIColor(named: "gray300")
            $0.layer.cornerRadius = 10
        }
        let text = UILabel().then {
            $0.text = "아직 습관이 없습니다"
            $0.font = .systemFont(ofSize: 15, weight: .medium)
        }
        let createButton = UIButton(type: .system).then {
            $0.setTitle("습관 생성", for: .normal)
            $0.tintColor = .white
            $0.backgroundColor = UIColor(named: "main600")
            $0.layer.cornerRadius = 10
            $0.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
        }
        
        card.addSubview(text)
        card.addSubview(createButton)
        text.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16)
        }
        createButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        return card
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        API()
        setLayout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    private func API() {
        provider.request(.getHabits) {
            switch $0 {
            case .success(let res):
                guard let data = try? res.map([habitInfo].self)
                else {
                    print("디코딩 실패. 습관 없을 수 있음")
                    self.noHabitCard.isHidden = false
                    self.habitProgressCard.isHidden = true
                    return
                }
                
                self.noHabitCard.isHidden = true
                self.habitProgressCard.isHidden = false
                
                var manager = HabitManager.shared
                manager.totalHabits = data.count//전체 습관 수 저장
                
                self.cardStackView.subviews.forEach { $0.removeFromSuperview() }
                self.cardStackView.addArrangedSubview(self.habitProgressCard)
                
                for i in 0..<data.count {
                    var habit = data[i]
                    
                    manager.name = habit.name
                    manager.category = habit.categorys.first
                    manager.didCount = habit.completedCount
                    manager.id = habit.habit_id
                    manager.periodType = habit.periodType
                    manager.didDays = habit.streak
                    habit.weekOfDay?.forEach {
                        manager.repeatDay?.append(Int($0))
                    }
                    self.createCard(id: i)
                }
                
            case .failure(let err):
                print(err)
            }
        }
    }
    private func setLayout() {
        view.addSubview(topBar)
        view.addSubview(scrollView)
        
        scrollView.addSubview(createButton)
        scrollView.addSubview(cardStackView)
        
        cardStackView.addArrangedSubview(habitProgressCard)
        cardStackView.addArrangedSubview(noHabitCard)
    
        topBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view)
            $0.height.equalTo(101)
        }
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(topBar.snp.bottom)
        }
        createButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalTo(scrollView.frameLayoutGuide).inset(24)
            $0.height.width.equalTo(25)
        }
        cardStackView.snp.makeConstraints {
            $0.top.equalTo(createButton.snp.bottom).offset(9)
            $0.leading.trailing.equalTo(scrollView.frameLayoutGuide).inset(24)
            $0.bottom.equalToSuperview().inset(24)
        }
        noHabitCard.snp.makeConstraints {
            $0.height.equalTo(116)
        }
    }//레이아웃 잡기
    @objc private func plusTapped() {
        navigationController?.pushViewController(HabitCreateViewController(), animated: false)
    }//생성 버튼 클릭 시 습관 생성 화면으로 이동
    
    private func createCard(id : Int) {
        let manager = HabitManager.shared
        
        var dayStr = ""
        manager.repeatDay?.forEach {
            switch $0 {
            case 1: dayStr += "월요일 "
            case 2: dayStr += "화요일 "
            case 3: dayStr += "수요일 "
            case 4: dayStr += "목요일 "
            case 5: dayStr += "금요일 "
            case 6: dayStr += "토요일 "
            case 7: dayStr += "일요일 "
            default : break
            }
        }
        //요일 문자열 설정
        
        let card = HabitCardView(
            id: manager.id,
            titleText: manager.name!,
            days: manager.didDays,
            times: manager.repeatCount!,
            didTimes: manager.didDays,
            category: manager.category!,
            cycle: manager.periodType!,
            day: dayStr
        )
        cardStackView.addArrangedSubview(card)
        
        card.onPatchButtonTapped = {
            self.navigationController?.pushViewController(HabitEditViewController(), animated: false)
            print("수정버튼 탭. id: \(id)")
        }
        
        card.onStatusChanged = {
            self.habitProgressCard.updateBar()
        }
        card.onStatusChanged?()
    }
}

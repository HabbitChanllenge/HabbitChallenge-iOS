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
    let hProvider = MoyaProvider<HabitAPI>(plugins: [MoyaLoggingPlugin()])
    let rProvider = MoyaProvider<StreakAPI>(plugins: [MoyaLoggingPlugin()])
    
    let navBar : NavigationBarView = NavigationBarView()
    
    let scrollView = UIScrollView()
    let wholeStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
        $0.alignment = .center
    }
    let habitStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.alignment = .center
    }
    
    let habitTextView = UIStackView().then {
        $0.axis = .horizontal//가로정렬 스택
        $0.distribution = .equalSpacing//양쪽 끝에 띄우겠다
        $0.alignment = .center
    }
    let rankTextView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }
    
    let habitText = UILabel().then {
        $0.text = "습관"
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor(named: "gray700")
    }
    let habitMoreButton = UIButton(type: .system).then {
        let attributedString = NSMutableAttributedString(string: "더보기")
        attributedString.addAttribute(.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.tintColor = UIColor(named: "gray700")
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        $0.contentHorizontalAlignment = .right
        $0.addTarget(self, action: #selector(habitMoreButtonDidTap), for: .touchUpInside)
    }
    let rankText = UILabel().then {
        $0.text = "랭킹"
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor(named: "gray700")
    }
    let rankMoreButton = UIButton(type: .system).then {
        let attributedString = NSMutableAttributedString(string: "더보기")
        attributedString.addAttribute(.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.tintColor = UIColor(named: "gray700")
        $0.titleLabel?.font = .systemFont(ofSize: 12, weight: .regular)
        $0.contentHorizontalAlignment = .right
        $0.addTarget(self, action: #selector(rankMoreButtonDidTap), for: .touchUpInside)
    }

    let top3RankCard : TopRankingView = TopRankingView()
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
            $0.addTarget(self, action: #selector(habitCreateButtonTapped), for: .touchUpInside)
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
    var progressCard : HabitProgressCardView = HabitProgressCardView()
    //--------------------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        navBar.streakLabel.text = "\(StreakManager.shared.allStreak)일"
        API()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setLayout()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        HabitManager.shared.reset()
    }
    //---------------------------------------------------------------------------
    private func setHabitCards(id: Int) {
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
        
        card.onStatusChanged = {
            let homeVC = self
            self.progressCard.updateBar()
        }
        habitStack.addArrangedSubview(card)
        card.onPatchButtonTapped = {[weak self] in//수정버튼 클릭 시 실행 클로저
            guard let self = self,
            let tabBarController = self.tabBarController else { return }
            tabBarController.swichTo(tab: .habit)// 탭을 어디로 이동할지
            
            DispatchQueue.main.async {
                if let nav = tabBarController.selectedViewController as? UINavigationController {
                    nav.pushViewController(HabitEditViewController(),animated: false)
                }
            }
        }
        manager.reset()
    }//습관 카드 생성 함수
    private func setLayout() {
        view.addSubview(navBar)
        view.addSubview(scrollView)
        
        scrollView.addSubview(wholeStack)
        wholeStack.addArrangedSubview(habitStack)
        wholeStack.addArrangedSubview(rankTextView)
        wholeStack.addArrangedSubview(top3RankCard)
        
        habitStack.addArrangedSubview(habitTextView)
        habitStack.addArrangedSubview(noHabitCard)
        
        habitTextView.addArrangedSubview(habitText)
        habitTextView.addArrangedSubview(habitMoreButton)
        
        rankTextView.addArrangedSubview(rankText)
        rankTextView.addArrangedSubview(rankMoreButton)
        
        navBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(101)
        }
        scrollView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(navBar.snp.bottom).offset(11)
        }
        wholeStack.snp.makeConstraints {
            $0.leading.trailing.equalTo(scrollView.frameLayoutGuide).inset(24)
            $0.top.bottom.equalToSuperview()
        }
        noHabitCard.snp.makeConstraints {
            $0.height.equalTo(116)
            $0.width.equalTo(354)
        }
        habitTextView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
        rankTextView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    @objc private func habitMoreButtonDidTap() {
        guard let tabBarController = self.tabBarController else { return }
        tabBarController.swichTo(tab: .habit)// 탭을 어디로 이동할지
    }
    @objc private func rankMoreButtonDidTap() {
        guard let tabBarController = self.tabBarController else { return }
        tabBarController.swichTo(tab: .ranking)// 탭을 어디로 이동할지
    }
    @objc private func habitCreateButtonTapped() {
        guard let tabBarController = self.tabBarController else { return }
        tabBarController.swichTo(tab: .habit)//습관탭으로 이동
        
        DispatchQueue.main.async {[weak self] in
            guard let self = self,
            let tabBarController = self.tabBarController else { return }
            tabBarController.swichTo(tab: .habit)

            DispatchQueue.main.async {
                if let nav = tabBarController.selectedViewController as? UINavigationController {
                    nav.pushViewController(HabitCreateViewController(),animated: false)
                }
            }
        }
    }
    private func API() {
        hProvider.request(.getHabits) {
            switch $0 {
            case .success(let res):
                guard let data = try? res.map([habitInfo].self) else { return }
                var manager = HabitManager.shared
                self.habitStack.subviews.forEach{ $0.removeFromSuperview() }
                
                let cnt = (data.count >= 3) ? 3 : data.count
                guard manager.totalHabits > 0 else {
                    self.habitStack.addArrangedSubview(self.noHabitCard)
                    self.noHabitCard.isHidden = false
                    
                    return
                }
                self.noHabitCard.isHidden = true
                
                for i in 0..<cnt {
                    var habit = data[i]
                    
                    manager.name = habit.name
                    manager.category = habit.categories.first
                    manager.didCount = habit.completedCount
                    manager.id = habit.habit_id
                    manager.didDays = habit.streak
                    manager.periodType = habit.periodType
                    manager.repeatCount = habit.totalRepeat
                    manager.isCompleted = habit.completed
                    habit.dayOfWeek?.forEach {
                        manager.repeatDay?.append(Int($0))
                    }
                    self.setHabitCards(id: i)
                }
                
            case .failure(let err):
                print(err)
            }
        }
        
        rProvider.request(.getRank) {
            switch $0 {
            case .success(let res):
                guard let data = try? res.map([RankData].self) else { return }
                if data.count >= 3 {//유저가 3명보다 많거나 3명일 시
                    self.top3RankCard.configure(firstName: data[0].userName, firstDays: data[0].allStreak, secondName: data[1].userName, secondDays: data[1].allStreak, thirdName: data[2].userName, thirdDays: data[2].allStreak)
                } else {//3명보다 적을 시
                    self.top3RankCard.firstNameLabel.text = data[0].userName
                    self.top3RankCard.firstDayLabel.text = "\(data[0].allStreak)일"
                    //1등은 무조건 있으니까 일단 설정
                    if data.count == 2 {
                        self.top3RankCard.firstNameLabel.text = data[1].userName
                        self.top3RankCard.firstDayLabel.text = "\(data[1].allStreak)일"
                    }
                    return//이 밑은 3명 이상일 때에만 실행 할거다.
                }
            case .failure(let err):
                return
            }
        }
    }
}

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
    let scrollView = UIScrollView()
    let wholeStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 24
    }
    let habitStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    let habitTextView = UIStackView().then {
        $0.axis = .horizontal//가로정렬 스택
        $0.distribution = .equalSpacing//양쪽 끝에 띄우겠다
        $0.alignment = .center
        $0.isLayoutMarginsRelativeArrangement = true//자체적으로 마진을 주겠냐? yes
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)//좌우로 24px씩 마진 줌
    }
    let rankTextView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
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
    let topHabitCard : HabitCardView = HabitCardView(titleText: "물마시기", days: 54, times: 10, didTimes: 4, category: "#일상", cycle: "매일")
    let middleHabitCard : HabitCardView = HabitCardView(titleText: "수영", days: 31, times: 1, didTimes: 0, category: "#건강", cycle: "금요일")
    let bottomHabitCard : HabitCardView = HabitCardView(titleText: "독서", days: 18, times: 1, didTimes: 1, category: "#자기계발", cycle: "매일")
    let top3RankCard : TopRankingView = TopRankingView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setLayout()
        topHabitCard.onPatchButtonTapped = { [weak self] in
            guard let self = self,
            let tabBarController = self.tabBarController else { return }
            tabBarController.swichTo(tab: .habit)// 탭을 어디로 이동할지

            DispatchQueue.main.async {
                if let nav = tabBarController.selectedViewController as? UINavigationController {
                    nav.pushViewController(HabitEditViewController(),animated: true)
                }
            }//탭이동 이후 화면 이동으로 순서 보장 위함
        }//top 카드 수정버튼. 수정 버튼 눌렸을 때 uiView에선 화면 전환이 불가하기 때문에 작성.
        middleHabitCard.onPatchButtonTapped = { [weak self] in
            guard let self = self,
            let tabBarController = self.tabBarController else { return }
            tabBarController.swichTo(tab: .habit)// 탭을 어디로 이동할지

            DispatchQueue.main.async {
                if let nav = tabBarController.selectedViewController as? UINavigationController {
                    nav.pushViewController(HabitEditViewController(),animated: true)
                }
            }//탭이동 이후 화면 이동으로 순서 보장 위함
        }//middle 카드 수정버튼. 수정 버튼 눌렸을 때 uiView에선 화면 전환이 불가하기 때문에 작성해주는 친구
        bottomHabitCard.onPatchButtonTapped = { [weak self] in
            guard let self = self,
            let tabBarController = self.tabBarController else { return }
            tabBarController.swichTo(tab: .habit)// 탭을 어디로 이동할지

            DispatchQueue.main.async {
                if let nav = tabBarController.selectedViewController as? UINavigationController {
                    nav.pushViewController(HabitEditViewController(),animated: true)
                }
            }//탭이동 이후 화면 이동으로 순서 보장 위함
        }//bottom 카드 수정버튼. 수정 버튼 눌렸을 때 uiView에선 화면 전환이 불가하기 때문에 작성해주는 친구
    }
    private func setLayout() {
        view.addSubview(navBar)
        view.addSubview(scrollView)
        
        scrollView.addSubview(wholeStack)
        wholeStack.addArrangedSubview(habitStack)
        wholeStack.addArrangedSubview(rankTextView)
        wholeStack.addArrangedSubview(top3RankCard)
        
        habitStack.addArrangedSubview(habitTextView)
        habitStack.addArrangedSubview(topHabitCard)
        habitStack.addArrangedSubview(middleHabitCard)
        habitStack.addArrangedSubview(bottomHabitCard)
        
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
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(navBar.snp.bottom).offset(11)
        }
        wholeStack.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
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
}

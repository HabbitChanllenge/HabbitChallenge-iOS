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

final class HabitEditViewController: UIViewController {
    private let provider = MoyaProvider<HabitAPI>(plugins: [MoyaLoggingPlugin()])

    private let topBar = NavigationBarView(streak: String(StreakManager.shared.allStreak))

    private let scrollView = UIScrollView()
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 19
    }
    
    private let habitNameView = HabitNameView()
    private let repeatCycleView = RepeatCycleView()
    private let categoryView = CategoryView()
    private let verificationCountView = VerificationCountView()
    private let habitEditButton = HabitCreateButton()
    private let weeklyDayView = WeeklyDayView()

    private let errorMessageLabel = UILabel().then {
        $0.text = "모든 항목을 선택해 주세요."
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = UIColor(named: "error")
        $0.isHidden = true
    }

    private let deleteButton = UIButton(type: .system).then {
        let attributedString = NSMutableAttributedString(string: "습관 삭제하기")
        attributedString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: attributedString.length)
        )
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.tintColor = UIColor(named: "gray600")
        $0.titleLabel?.font = .systemFont(ofSize: 15)
    }
    
    private var isNameFilled: Bool = false
    private var isCategorySelected = false
    private var isVerificationSelected = false
    private var isWeekDaySelected = false
    private var isNotificationSelected = true

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        habitEditButton.createButton.setTitle("수정하기", for: .normal)
        habitEditButton.setEnabled(true)
        
        habitEditButton.createButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)//수정 버튼 연결
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)//삭제버튼 연결

        setupUI()
        setupLayout()
        setupCycleAction()
        setupSelectionAction()
    }

    private func setupCycleAction() {

        repeatCycleView.onCycleChanged = { [weak self] isWeekly in

            guard let self else { return }

            self.verificationCountView.isHidden = isWeekly
            self.weeklyDayView.isHidden = !isWeekly

            if isWeekly {
                self.isVerificationSelected = false
            } else {
                self.isWeekDaySelected = false
            }
        }
    }

    private func setupSelectionAction() {
        habitNameView.nameEditing = { [weak self] isNil in
            self?.isNameFilled = !isNil
        }
        categoryView.onCategorySelected = { [weak self] in
            self?.isCategorySelected = true
        }

        verificationCountView.onCountSelected = { [weak self] in
            self?.isVerificationSelected = true
        }

        weeklyDayView.onDaySelected = { [weak self] selected in
            self?.isWeekDaySelected = selected
        }
    }

    @objc private func editButtonTapped() {

        let authenticationSelected: Bool = weeklyDayView.isHidden ? isVerificationSelected : isWeekDaySelected
        let isWeekly = !weeklyDayView.isHidden

        let isComplete =
            isNameFilled &&
            isCategorySelected &&
            authenticationSelected &&
            isNotificationSelected
        
        errorMessageLabel.isHidden = isComplete

        if isComplete {
            // 습관 수정 로직 연결 예정
        }
    }

    @objc private func deleteButtonTapped() {
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: "", preferredStyle: .alert)
        let delete = UIAlertAction(title: "삭제", style: .destructive) {_ in 
            self.provider.request(.deleteHabit(habitId: HabitManager.shared.id)) {
                switch $0 {
                case .success(let res):
                    guard let data = try? res.map(response.self) else { return }
                    if data.statusCode == 200 {
                        self.navigationController?.popViewController(animated: true)
                    } else if data.statusCode == 401 {
                        let alert = UIAlertController(title: "로그인이 필요합니다.", message: "", preferredStyle: .alert)
                        let cansle = UIAlertAction(title: "확인", style: .cancel)
                        alert.addAction(cansle)
                        self.present(alert, animated: true)
                    }
                case .failure:
                    print("failure")
                }
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true)
    }

    private func setupUI() {
        view.addSubview(topBar)
        view.addSubview(scrollView)

        scrollView.addSubview(stackView)
        scrollView.addSubview(deleteButton)

        stackView.addArrangedSubview(habitNameView)
        stackView.addArrangedSubview(repeatCycleView)
        stackView.addArrangedSubview(categoryView)
        stackView.addArrangedSubview(verificationCountView)
        stackView.addArrangedSubview(weeklyDayView)
        stackView.addArrangedSubview(errorMessageLabel)
        stackView.addArrangedSubview(habitEditButton)

        weeklyDayView.isHidden = true
    }

    private func setupLayout() {

        topBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(101)
        }
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints {
            $0.top.equalTo(scrollView.contentLayoutGuide)
            $0.leading.trailing.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(scrollView.contentLayoutGuide).inset(58)
        }
        deleteButton.snp.makeConstraints {
            $0.trailing.equalTo(stackView).inset(24)
            $0.top.equalTo(stackView.snp.bottom).offset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
}

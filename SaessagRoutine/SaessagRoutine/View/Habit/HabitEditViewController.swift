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

    private let topBar = NavigationBarView(streak: "31")

    private let scrollView = UIScrollView()

    private let contentView = UIView()

    private let habitNameView = HabitNameView()
    private let repeatCycleView = RepeatCycleView()
    private let categoryView = CategoryView()
    private let verificationCountView = VerificationCountView()
    private let notificationView = NotificationView()
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
        $0.titleLabel?.font = .systemFont(ofSize: 14)
    }

    private var isCycleSelected = true
    private var isCategorySelected = false
    private var isVerificationSelected = false
    private var isWeekDaySelected = false
    private var isNotificationSelected = true

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        habitEditButton.createButton.setTitle("수정하기", for: .normal)
        habitEditButton.setEnabled(true)

        setupUI()
        setupLayout()
        setupCycleAction()
        setupSelectionAction()
        setupEditAction()
    }

    private func setupCycleAction() {

        repeatCycleView.onCycleChanged = { [weak self] isWeekly in

            guard let self else { return }

            self.isCycleSelected = true

            self.verificationCountView.isHidden = isWeekly
            self.weeklyDayView.isHidden = !isWeekly

            if isWeekly {
                self.isVerificationSelected = false
            } else {
                self.isWeekDaySelected = false
            }

            self.updateLayoutForCycle(isWeekly: isWeekly)
        }
    }

    private func setupSelectionAction() {

        categoryView.onCategorySelected = { [weak self] in
            self?.isCategorySelected = true
        }

        verificationCountView.onCountSelected = { [weak self] in
            self?.isVerificationSelected = true
        }

        weeklyDayView.onDaySelected = { [weak self] selected in
            self?.isWeekDaySelected = selected
        }

        notificationView.onNotificationSelected = { [weak self] in
            self?.isNotificationSelected = true
        }
    }

    private func setupEditAction() {

        habitEditButton.createButton.addTarget(
            self,
            action: #selector(editButtonTapped),
            for: .touchUpInside
        )

        deleteButton.addTarget(
            self,
            action: #selector(deleteButtonTapped),
            for: .touchUpInside
        )
    }

    @objc private func editButtonTapped() {

        let authenticationSelected: Bool

        if weeklyDayView.isHidden {
            authenticationSelected = isVerificationSelected
        } else {
            authenticationSelected = isWeekDaySelected
        }

        let isComplete =
            isCycleSelected &&
            isCategorySelected &&
            authenticationSelected &&
            isNotificationSelected

        errorMessageLabel.isHidden = isComplete

        if isComplete {
            // 습관 수정 로직 연결 예정
        }
    }

    @objc private func deleteButtonTapped() {
        // 습관 삭제 로직 연결 예정
    }

    private func updateLayoutForCycle(isWeekly: Bool) {

        if isWeekly {

            weeklyDayView.snp.remakeConstraints {
                $0.top.equalTo(categoryView.snp.bottom).offset(18)
                $0.leading.trailing.equalToSuperview().inset(15)
                $0.height.equalTo(220)
            }

            notificationView.snp.remakeConstraints {
                $0.top.equalTo(weeklyDayView.snp.bottom).offset(18)
                $0.leading.trailing.equalToSuperview().inset(15)
                $0.height.equalTo(104)
            }

        } else {

            verificationCountView.snp.remakeConstraints {
                $0.top.equalTo(categoryView.snp.bottom).offset(18)
                $0.leading.trailing.equalToSuperview().inset(15)
                $0.height.equalTo(266)
            }

            notificationView.snp.remakeConstraints {
                $0.top.equalTo(verificationCountView.snp.bottom).offset(18)
                $0.leading.trailing.equalToSuperview().inset(15)
                $0.height.equalTo(104)
            }
        }
    }

    private func setupUI() {
        view.addSubview(topBar)
        view.addSubview(scrollView)

        scrollView.addSubview(contentView)

        contentView.addSubview(habitNameView)
        contentView.addSubview(repeatCycleView)
        contentView.addSubview(categoryView)
        contentView.addSubview(verificationCountView)
        contentView.addSubview(weeklyDayView)
        contentView.addSubview(notificationView)
        contentView.addSubview(errorMessageLabel)
        contentView.addSubview(habitEditButton)
        contentView.addSubview(deleteButton)

        weeklyDayView.isHidden = true
    }

    private func setupLayout() {

        topBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(101)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

        habitNameView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(111)
        }

        repeatCycleView.snp.makeConstraints {
            $0.top.equalTo(habitNameView.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(104)
        }

        categoryView.snp.makeConstraints {
            $0.top.equalTo(repeatCycleView.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(212)
        }

        verificationCountView.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(266)
        }

        weeklyDayView.snp.makeConstraints {
            $0.top.equalTo(categoryView.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(220)
        }

        notificationView.snp.makeConstraints {
            $0.top.equalTo(verificationCountView.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(104)
        }

        errorMessageLabel.snp.makeConstraints {
            $0.top.equalTo(notificationView.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(15)
        }

        habitEditButton.snp.makeConstraints {
            $0.top.equalTo(errorMessageLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(80)
        }

        deleteButton.snp.makeConstraints {
            $0.top.equalTo(habitEditButton.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}

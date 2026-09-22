import UIKit
import SnapKit
import Then
import Moya

final class HabitCreateViewController: UIViewController {
    
    private let topBar = NavigationBarView(streak: "31")
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    private let habitNameView = HabitNameView()
    private let repeatCycleView = RepeatCycleView()
    private let categoryView = CategoryView()
    private let verificationCountView = VerificationCountView()
    private let notificationView = NotificationView()
    private let habitCreateButton = HabitCreateButton()
    private let weeklyDayView = WeeklyDayView()
    
    private var isCycleSelected = true
    private var isCategorySelected = false
    private var isVerificationSelected = false
    private var isWeekDaySelected = false
    private var isNotificationSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupUI()
        setupLayout()
        setupCycleAction()
        setupSelectionAction()
        updateCreateButton()
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

            self.updateCreateButton()
            self.updateLayoutForCycle(isWeekly: isWeekly)
        }
    }
    
    private func setupSelectionAction() {

        categoryView.onCategorySelected = { [weak self] in
            self?.isCategorySelected = true
            self?.updateCreateButton()
        }

        verificationCountView.onCountSelected = { [weak self] in
            self?.isVerificationSelected = true
            self?.updateCreateButton()
        }

        weeklyDayView.onDaySelected = { [weak self] selected in
            self?.isWeekDaySelected = selected
            self?.updateCreateButton()
        }

        notificationView.onNotificationSelected = { [weak self] in
            self?.isNotificationSelected = true
            self?.updateCreateButton()
        }
    }
    
    private func updateCreateButton() {

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

        habitCreateButton.setEnabled(isComplete)
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
        contentView.addSubview(habitCreateButton)
        
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
        
        habitCreateButton.snp.makeConstraints {
            $0.top.equalTo(notificationView.snp.bottom).offset(18)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(80)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}

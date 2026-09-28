import UIKit
import SnapKit
import Then
import Moya

final class HabitCreateViewController: UIViewController {
    
    private let topBar = NavigationBarView(streak: "31")
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 19
    }
        
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

            self.verificationCountView.isHidden = isWeekly//인증 횟수 선택 숨김 여부
            self.weeklyDayView.isHidden = !isWeekly//인증 요일 선택 숨김 여부

            self.isVerificationSelected = !isWeekly
            self.isWeekDaySelected = isWeekly
            //선택 됐었던 값 초기화

            self.updateCreateButton()
        }//하루에서 일주일으로, 일주일에서 하루로 인증 주기 바꿨을 때 실행 클로저
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
    
    private func setupUI() {
        view.addSubview(topBar)
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(habitNameView)
        stackView.addArrangedSubview(repeatCycleView)
        stackView.addArrangedSubview(categoryView)
        stackView.addArrangedSubview(verificationCountView)
        stackView.addArrangedSubview(weeklyDayView)
        stackView.addArrangedSubview(notificationView)
        stackView.addArrangedSubview(habitCreateButton)
        
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
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.leading.trailing.equalTo(scrollView.frameLayoutGuide)
        }
    }//레이아웃 잡기
}

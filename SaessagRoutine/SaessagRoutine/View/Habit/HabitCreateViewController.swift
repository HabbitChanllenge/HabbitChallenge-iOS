import UIKit
import SnapKit
import Then
import Moya

final class HabitCreateViewController: UIViewController {
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
    private let habitCreateButton : HabitCreateButton = HabitCreateButton()
    private let weeklyDayView = WeeklyDayView()
    private let errorMassage = UIButton().then {
        $0.isHidden = true
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        $0.contentHorizontalAlignment = .leading
        $0.isUserInteractionEnabled = false
        
        var config = UIButton.Configuration.plain()
        config.contentInsets.leading = 24
        $0.configuration = config
        $0.setTitle("", for: .normal)
        $0.setTitleColor(UIColor(named: "error"), for: .normal)
    }
    
    private var isNameFilled: Bool = false
    private var isCategorySelected = false
    private var isVerificationSelected = false
    private var isWeekDaySelected = false
    private var isNotificationSelected = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        habitCreateButton.createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)

        setupLayout()
        setupCycleAction()
        setupSelectionAction()
        updateCreateButton()
    }
    
    private func setupCycleAction() {
        repeatCycleView.onCycleChanged = { [weak self] isWeekly in
            guard let self else { return }

            self.verificationCountView.isHidden = isWeekly//인증 횟수 선택 숨김 여부
            self.weeklyDayView.isHidden = !isWeekly//인증 요일 선택 숨김 여부

            self.isVerificationSelected = !isWeekly
            self.isWeekDaySelected = isWeekly
            self.verificationCountView.countButtons.forEach {
                $0.backgroundColor = UIColor(named: "main300")
                $0.setTitleColor(UIColor(named: "main800"), for: .normal)
            }
            self.weeklyDayView.dayButtons.forEach {
                $0.backgroundColor = UIColor(named: "main300")
                $0.setTitleColor(UIColor(named: "main800"), for: .normal)
            }
            //선택 됐었던 값 초기화
            
            self.setupSelectionAction()
            self.updateCreateButton()
        }//하루에서 일주일으로, 일주일에서 하루로 인증 주기 바꿨을 때 실행 클로저
    }
    
    private func setupSelectionAction() {
        habitNameView.nameEditing = { [weak self] isNil in
            self?.isNameFilled = !isNil
            self?.updateCreateButton()
        }
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
    }
    
    private func updateCreateButton() {
        let authenticationSelected: Bool

        if weeklyDayView.isHidden {
            authenticationSelected = isVerificationSelected
        } else {
            authenticationSelected = isWeekDaySelected
        }

        let isComplete =
            isNameFilled &&
            isCategorySelected &&
            authenticationSelected &&
            isNotificationSelected

        habitCreateButton.setEnabled(isComplete)
    }
    private func setupLayout() {
        view.addSubview(topBar)
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(habitNameView)
        stackView.addArrangedSubview(repeatCycleView)
        stackView.addArrangedSubview(categoryView)
        stackView.addArrangedSubview(verificationCountView)
        stackView.addArrangedSubview(weeklyDayView)
        stackView.addArrangedSubview(errorMassage)
        stackView.addArrangedSubview(habitCreateButton)
        
        weeklyDayView.isHidden = true
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
            $0.bottom.equalTo(scrollView.contentLayoutGuide).inset(24)
            $0.leading.trailing.equalTo(scrollView.frameLayoutGuide)
        }
        errorMassage.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(18)
        }
    }//레이아웃 잡기
    @objc private func createButtonTapped() {
        print("버튼 연동 성공")
        let manager = HabitManager.shared
        guard manager.name != nil else { print("이름 비어있음"); return }
        
        if manager.periodType == "week" {
            provider.request(.weekCreateHabit(periodType: "week", name: manager.name ?? "", categorys: manager.category ?? "", dayOfWeek: manager.repeatDay ?? [])) {
                switch $0 {
                case .success(let res):
                    guard let data = try? res.map(response.self) else { return }
                    if data.statusCode == 200 {
                        self.navigationController?.popViewController(animated: true)
                        print("생성 성공 야호")
                        manager.reset()
                    } else if data.statusCode == 400 {
                        self.errorMassage.setTitle("잘못된 형식입니다.", for: .normal)
                        self.errorMassage.isHidden = false
                    } else if data.statusCode == 401 {
                        self.errorMassage.setTitle("로그인 상태가 아닙니다.", for: .normal)
                        self.errorMassage.isHidden = false
                    }
                case .failure:
                    print("연동 실패")
                }
            }
        } else {
            provider.request(.dayCreateHabit(periodType: "day", name: manager.name ?? "", categorys: manager.category ?? "", totalRepeat: manager.repeatCount ?? 0)) {
                switch $0 {
                case .success(let res):
                    guard let data = try? res.map(response.self) else { return }
                    if data.statusCode == 200 {
                        HabitManager.shared.reset()
                        self.navigationController?.popViewController(animated: true)
                    } else if data.statusCode == 400 {
                        self.errorMassage.setTitle("잘못된 형식입니다.", for: .normal)
                        self.errorMassage.isHidden = false
                    } else if data.statusCode == 401 {
                        self.errorMassage.setTitle("로그인 상태가 아닙니다.", for: .normal)
                        self.errorMassage.isHidden = false
                    }
                case .failure:
                    return print("연동 실패")
                }
            }
        }
    }
}

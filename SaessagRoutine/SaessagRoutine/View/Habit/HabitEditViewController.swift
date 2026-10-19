import UIKit
import SnapKit
import Then
import Moya

final class HabitEditViewController: UIViewController {
    private let provider = MoyaProvider<HabitAPI>(plugins: [MoyaLoggingPlugin()])
    private let habit: habitInfo

    private let topBar = NavigationBarView()
    private let scrollView = UIScrollView()
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 19
    }

    private let habitNameView = HabitNameView("")
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
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
        $0.setAttributedTitle(attributedString, for: .normal)
        $0.tintColor = UIColor(named: "gray600")
        $0.titleLabel?.font = .systemFont(ofSize: 15)
    }

    init(habit: habitInfo) {
        self.habit = habit
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        habitEditButton.createButton.setTitle("수정하기", for: .normal)
        habitEditButton.setEnabled(true)
        habitEditButton.createButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

        setupUI()
        setupLayout()
        setupCycleAction()
        configureInitialValues()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        topBar.streakLabel.text = "\(StreakManager.shared.allStreak)일"
    }

    private func configureInitialValues() {
        habitNameView.configure(name: habit.name)
        repeatCycleView.configure(periodType: habit.periodType)
        categoryView.configure(category: habit.categories.first ?? "")

        let isWeekly = habit.periodType == "week"
        verificationCountView.isHidden = isWeekly
        weeklyDayView.isHidden = !isWeekly
        verificationCountView.configure(count: habit.totalRepeat)
        weeklyDayView.configure(selectedDays: habit.dayOfWeek ?? [])
    }

    private func setupCycleAction() {
        repeatCycleView.onCycleChanged = { [weak self] isWeekly in
            guard let self else { return }
            self.verificationCountView.isHidden = isWeekly
            self.weeklyDayView.isHidden = !isWeekly
        }
    }

    @objc private func editButtonTapped() {
        guard let name = habitNameView.textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !name.isEmpty,
              let category = categoryView.selectedCategory,
              !category.isEmpty else {
            errorMessageLabel.isHidden = false
            return
        }

        let isWeekly = repeatCycleView.periodType == "week"
        let repeatCount = verificationCountView.selectedCount
        let selectedDays = weeklyDayView.selectedDays.sorted()

        guard (!isWeekly && repeatCount != nil) || (isWeekly && !selectedDays.isEmpty) else {
            errorMessageLabel.isHidden = false
            return
        }

        errorMessageLabel.isHidden = true

        provider.request(
            .patchHabit(
                habitId: habit.habit_id,
                periodType: isWeekly ? "week" : "day",
                name: name,
                categorys: category,
                totalRepeat: isWeekly ? nil : repeatCount,
                dayOfWeek: isWeekly ? selectedDays : nil
            )
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let networkResponse):
                guard let data = try? networkResponse.map(response.self) else { return }
                if data.statusCode == 200 {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.errorMessageLabel.text = data.message
                    self.errorMessageLabel.isHidden = false
                }
            case .failure:
                self.errorMessageLabel.text = "습관 수정에 실패했습니다."
                self.errorMessageLabel.isHidden = false
            }
        }
    }

    @objc private func deleteButtonTapped() {
        let alert = UIAlertController(title: "삭제하시겠습니까?", message: "", preferredStyle: .alert)
        let delete = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.provider.request(.deleteHabit(habitId: self.habit.habit_id)) { result in
                guard case let .success(networkResponse) = result,
                      let data = try? networkResponse.map(response.self),
                      data.statusCode == 200 else { return }
                self.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(delete)
        present(alert, animated: true)
    }

    private func setupUI() {
        view.addSubview(topBar)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(deleteButton)

        [habitNameView, repeatCycleView, categoryView, verificationCountView, weeklyDayView, errorMessageLabel, habitEditButton].forEach {
            stackView.addArrangedSubview($0)
        }
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

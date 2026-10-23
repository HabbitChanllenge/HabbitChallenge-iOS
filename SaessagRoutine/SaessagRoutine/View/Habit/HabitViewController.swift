import UIKit
import SnapKit
import Then
import Moya

final class HabitViewController: UIViewController {
    private let provider = MoyaProvider<HabitAPI>(plugins: [MoyaLoggingPlugin()])
    private let rProvider = MoyaProvider<StreakAPI>(plugins: [MoyaLoggingPlugin()])
    private var habits: [habitInfo] = []

    private let topBar = NavigationBarView()
    private let createButton = UIButton(type: .system).then {
        $0.imageView?.contentMode = .scaleAspectFit
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.tintColor = UIColor(named: "main800")
        $0.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
    }
    private let cardStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    private let scrollView = UIScrollView()
    private let habitProgressCard = HabitProgressCardView()

    private let noHabitCard: UIView = {
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
        text.snp.makeConstraints { $0.top.leading.equalToSuperview().inset(16) }
        createButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(24)
        }
        return card
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        HabitManager.shared.reset()
        topBar.streakLabel.text = "\(StreakManager.shared.allStreak)일"
        fetchHabits()
    }

    private func fetchHabits() {
        provider.request(.getHabits) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                guard let habits = try? response.map([habitInfo].self) else {
                    print("습관 목록 디코딩 실패")
                    return
                }
                self.habits = habits
                self.renderHabits()
            case .failure(let error):
                print(error)
            }
        }
    }

    private func renderHabits() {
        cardStackView.arrangedSubviews.forEach {
            cardStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        cardStackView.addArrangedSubview(habitProgressCard)
        HabitManager.shared.totalHabits = habits.count

        guard !habits.isEmpty else {
            habitProgressCard.isHidden = true
            cardStackView.addArrangedSubview(noHabitCard)
            return
        }

        habitProgressCard.isHidden = false
        habits.forEach(createCard)
    }

    private func setLayout() {
        view.addSubview(topBar)
        view.addSubview(scrollView)
        scrollView.addSubview(createButton)
        scrollView.addSubview(cardStackView)

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
        noHabitCard.snp.makeConstraints { $0.height.equalTo(116) }
    }

    @objc private func plusTapped() {
        navigationController?.pushViewController(HabitCreateViewController(), animated: false)
    }

    private func createCard(habit: habitInfo) {
        let dayText = (habit.dayOfWeek ?? []).compactMap { day -> String? in
            switch day {
            case 1: return "일요일"
            case 2: return "월요일"
            case 3: return "화요일"
            case 4: return "수요일"
            case 5: return "목요일"
            case 6: return "금요일"
            case 7: return "토요일"
            default: return nil
            }
        }.joined(separator: " ")

        let card = HabitCardView(
            id: habit.habit_id,
            titleText: habit.name,
            days: habit.streak,
            times: max(habit.totalRepeat ?? 1, 1),
            didTimes: habit.completedCount,
            category: habit.categories.first ?? "",
            cycle: habit.periodType,
            day: dayText,
            complated: habit.completed
        )
        cardStackView.addArrangedSubview(card)

        card.onPatchButtonTapped = { [weak self] _ in
            self?.navigationController?.pushViewController(
                HabitEditViewController(habit: habit),
                animated: false
            )
        }
        card.onStatusChanged = { [weak self] in
            self?.habitProgressCard.updateBar()
            self?.rProvider.request(.getStreak) {
                switch $0 {
                case .success(let res):
                    guard let data = try? res.map(Streak.self) else { print("디코딩 실패"); return }
                    StreakManager.shared.allStreak = data.allStreak
                case .failure(let err):
                    print(err)
                }
            }
        }
        card.onVerifiyed = { id, didTimes in
            self.provider.request(.verifyHabit(habitId: id, completedCount: didTimes)) {
                switch $0 {
                case .success(let res):
                    guard let data = try? res.map(response.self) else { print("습관 인증 이후 디코딩 실패"); return }
                    if data.statusCode == 200 {
                        
                        let isCompleted = (card.didTimes >= card.times)//인증 성공 여부 판단
                        if isCompleted {
                            card.verificationButton.isEnabled = false
                            card.verificationButton.backgroundColor = UIColor(named: "main500")
                            card.habitCard.backgroundColor = UIColor(named: "main300")
                            HabitManager.shared.didHabits += 1
                            card.onStatusChanged?()
                        }//성공 했으면 인증버튼 비활성화, 배경색 변경
                    }
                case .failure(let err):
                    print(err)
                }
                
            }
        }
        card.onStatusChanged?()
    }
}

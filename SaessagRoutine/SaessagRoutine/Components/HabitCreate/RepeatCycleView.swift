import UIKit
import SnapKit
import Then

final class RepeatCycleView: UIView {

    var onCycleChanged: ((Bool) -> Void)?

    private let titleLabel = UILabel().then {
        $0.text = "반복 주기"
        $0.font = .systemFont(ofSize: 25, weight: .semibold)
        $0.textColor = UIColor(named: "gray900")
    }

    private let dayButton = UIButton().then {
        $0.setTitle("하루", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.layer.cornerRadius = 15
    }

    private let weekButton = UIButton().then {
        $0.setTitle("일주일", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.layer.cornerRadius = 15
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        addSubview(titleLabel)
        addSubview(dayButton)
        addSubview(weekButton)

        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.equalTo(40)
        }

        dayButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.width.equalTo(88)
            $0.height.equalTo(44)
        }

        weekButton.snp.makeConstraints {
            $0.top.equalTo(dayButton)
            $0.leading.equalTo(dayButton.snp.trailing).offset(20)
            $0.width.equalTo(88)
            $0.height.equalTo(44)
        }

        updateButton(dayButton, selected: true)
        updateButton(weekButton, selected: false)
    }

    private func setupAction() {

        dayButton.addTarget(
            self,
            action: #selector(didTapDay),
            for: .touchUpInside
        )

        weekButton.addTarget(
            self,
            action: #selector(didTapWeek),
            for: .touchUpInside
        )
    }

    private func updateButton(
        _ button: UIButton,
        selected: Bool
    ) {

        button.backgroundColor = UIColor(
            named: selected ? "main600" : "main300"
        )

        button.setTitleColor(
            UIColor(
                named: selected ? "gray100" : "main800"
            ),
            for: .normal
        )
    }

    @objc private func didTapDay() {

        updateButton(dayButton, selected: true)
        updateButton(weekButton, selected: false)

        onCycleChanged?(false)
    }

    @objc private func didTapWeek() {

        updateButton(dayButton, selected: false)
        updateButton(weekButton, selected: true)

        onCycleChanged?(true)
    }
}

import UIKit
import SnapKit
import Then

final class RepeatCycleView: UIView {

    private let titleLabel = UILabel().then {
        $0.text = "반복 주기"
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.textColor = UIColor(named: "gray900")
    }

    private let dayButton = UIButton().then {
        $0.setTitle("하루", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12)
    }

    private let weekButton = UIButton().then {
        $0.setTitle("일주일", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 12)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        addSubview(dayButton)
        addSubview(weekButton)

        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.equalTo(40)
        }

        dayButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.bottom.equalToSuperview()
            $0.width.equalTo(88)
            $0.height.equalTo(24)
        }

        weekButton.snp.makeConstraints {
            $0.top.equalTo(dayButton)
            $0.leading.equalTo(dayButton.snp.trailing).offset(20)
            $0.width.equalTo(88)
            $0.height.equalTo(24)
        }

        setupButton(dayButton, selected: true)
        setupButton(weekButton, selected: false)

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

    private func setupButton(_ button: UIButton, selected: Bool) {
        button.backgroundColor = UIColor(
            named: selected ? "main600" : "main300"
        )

        button.setTitleColor(
            UIColor(
                named: selected ? "gray100" : "main800"
            ),
            for: .normal
        )

        button.layer.cornerRadius = 12
    }

    @objc private func didTapDay() {
        setupButton(dayButton, selected: true)
        setupButton(weekButton, selected: false)
    }

    @objc private func didTapWeek() {
        setupButton(dayButton, selected: false)
        setupButton(weekButton, selected: true)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import UIKit
import SnapKit
import Then

final class WeeklyDayView: UIView {
    var onDaySelected: ((Bool) -> Void)?

    private let titleLabel = UILabel().then {
        $0.text = "인증 요일"
        $0.font = .systemFont(ofSize: 25, weight: .semibold)
        $0.textColor = UIColor(named: "gray900")
    }

    private var dayButtons: [UIButton] = []

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeButton(_ title: String) -> UIButton {
        let button = UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 14)
            $0.layer.cornerRadius = 15
            $0.backgroundColor = UIColor(named: "main300")
            $0.setTitleColor(
                UIColor(named: "main800"),
                for: .normal
            )
        }

        button.addTarget(
            self,
            action: #selector(dayTapped(_:)),
            for: .touchUpInside
        )

        dayButtons.append(button)

        return button
    }

    private func setupUI() {

        addSubview(titleLabel)

        let firstRow = UIStackView(
            arrangedSubviews: [
                makeButton("월요일"),
                makeButton("화요일"),
                makeButton("수요일")
            ]
        ).then {
            $0.axis = .horizontal
            $0.spacing = 20
        }

        let secondRow = UIStackView(
            arrangedSubviews: [
                makeButton("목요일"),
                makeButton("금요일"),
                makeButton("토요일")
            ]
        ).then {
            $0.axis = .horizontal
            $0.spacing = 20
        }

        let thirdRow = UIStackView(
            arrangedSubviews: [
                makeButton("일요일")
            ]
        ).then {
            $0.axis = .horizontal
            $0.spacing = 20
        }

        addSubview(firstRow)
        addSubview(secondRow)
        addSubview(thirdRow)

        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.equalTo(40)
        }

        firstRow.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.height.equalTo(44)
        }

        secondRow.snp.makeConstraints {
            $0.top.equalTo(firstRow.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.height.equalTo(44)
        }

        thirdRow.snp.makeConstraints {
            $0.top.equalTo(secondRow.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.height.equalTo(44)
        }

        dayButtons.forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(108)
                $0.height.equalTo(44)
            }
        }
    }

    @objc private func dayTapped(_ sender: UIButton) {

        let isSelected =
            sender.backgroundColor == UIColor(named: "main600")

        if isSelected {
            sender.backgroundColor = UIColor(named: "main300")
            sender.setTitleColor(
                UIColor(named: "main800"),
                for: .normal
            )
        } else {
            sender.backgroundColor = UIColor(named: "main600")
            sender.setTitleColor(
                .white,
                for: .normal
            )
        }

        let hasSelectedDay = dayButtons.contains {
            $0.backgroundColor == UIColor(named: "main600")
        }

        onDaySelected?(hasSelectedDay)
    }
}

import UIKit
import SnapKit
import Then

final class NotificationView: UIView {

    var onNotificationSelected: (() -> Void)?

    private let titleLabel = UILabel().then {
        $0.text = "알림 받기"
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.textColor = UIColor(named: "gray900")
    }

    private let offButton = UIButton().then {
        $0.setTitle("끄기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.layer.cornerRadius = 12
    }

    private let onButton = UIButton().then {
        $0.setTitle("켜기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.layer.cornerRadius = 12
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        addSubview(offButton)
        addSubview(onButton)

        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.equalTo(40)
        }

        offButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.width.equalTo(169)
            $0.height.equalTo(44)
        }

        onButton.snp.makeConstraints {
            $0.top.equalTo(offButton)
            $0.leading.equalTo(offButton.snp.trailing).offset(15)
            $0.width.equalTo(169)
            $0.height.equalTo(44)
        }

        updateButton(offButton, selected: false)
        updateButton(onButton, selected: true)

        offButton.addTarget(
            self,
            action: #selector(didTapOff),
            for: .touchUpInside
        )

        onButton.addTarget(
            self,
            action: #selector(didTapOn),
            for: .touchUpInside
        )
    }

    private func updateButton(
        _ button: UIButton,
        selected: Bool
    ) {

        button.backgroundColor = UIColor(
            named: selected ? "main600" : "gray200"
        )

        button.setTitleColor(
            UIColor(named: "main800"),
            for: .normal
        )
    }

    @objc private func didTapOff() {

        updateButton(offButton, selected: true)
        updateButton(onButton, selected: false)

        onNotificationSelected?()
    }

    @objc private func didTapOn() {

        updateButton(offButton, selected: false)
        updateButton(onButton, selected: true)

        onNotificationSelected?()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

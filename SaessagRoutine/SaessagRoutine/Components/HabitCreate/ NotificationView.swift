import UIKit
import SnapKit
import Then

final class NotificationView: UIView {

    var onNotificationSelected: (() -> Void)?

    private let titleLabel = UILabel().then {
        $0.text = "알림 받기"
        $0.font = .systemFont(ofSize: 25, weight: .semibold)
        $0.textColor = UIColor(named: "gray900")
    }

    private let offButton = UIButton(type: .system).then {
        $0.setTitle("끄기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(didTapOff), for: .touchUpInside)
    }

    private let onButton = UIButton(type: .system).then {
        $0.setTitle("켜기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(didTapOn), for: .touchUpInside)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        addSubview(offButton)
        addSubview(onButton)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
        }

        offButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(19)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(169)
            $0.height.equalTo(44)
        }

        onButton.snp.makeConstraints {
            $0.centerY.equalTo(offButton)
            $0.leading.equalTo(offButton.snp.trailing).offset(16)
            $0.width.equalTo(offButton)
            $0.height.equalTo(offButton)
            $0.bottom.equalToSuperview()
        }

        updateButton(offButton, selected: false)
        updateButton(onButton, selected: true)
    }

    private func updateButton(
        _ button: UIButton,
        selected: Bool
    ) {

        button.backgroundColor = UIColor(
            named: selected ? "main600" : "gray200"
        )

        button.setTitleColor(
            selected ? .white : UIColor(named: "main800"), for: .normal,
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

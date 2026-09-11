import UIKit
import SnapKit
import Then

final class VerificationCountView: UIView {

    private let titleLabel = UILabel().then {
        $0.text = "주기당 인증횟수"
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.textColor = UIColor(named: "gray900")
    }

    private var countButtons: [UIButton] = []

    private let moreButton = UIButton().then {
        $0.setTitle("그 이상", for: .normal)
        $0.setTitleColor(
            UIColor(named: "main800"),
            for: .normal
        )
        $0.backgroundColor = UIColor(named: "main300")
        $0.layer.cornerRadius = 12
        $0.titleLabel?.font = .systemFont(ofSize: 12)
    }

    private let moreTextField = UITextField().then {
        $0.placeholder = "숫자로만 입력해 주세요. 예) 12"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = UIColor(named: "main800")
        $0.backgroundColor = UIColor(named: "main300")
        $0.keyboardType = .numberPad
        $0.borderStyle = .none
    }

    private let moreContainer = UIView().then {
        $0.backgroundColor = UIColor(named: "main300")
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
        setupLayout()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeButton(_ title: String) -> UIButton {

        let button = UIButton().then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(
                UIColor(named: "main800"),
                for: .normal
            )
            $0.backgroundColor = UIColor(named: "main300")
            $0.layer.cornerRadius = 12
            $0.titleLabel?.font = .systemFont(ofSize: 12)
        }

        button.addTarget(
            self,
            action: #selector(countTapped(_:)),
            for: .touchUpInside
        )

        countButtons.append(button)

        return button
    }

    private func setupUI() {

        addSubview(titleLabel)

        let firstRow = UIStackView(
            arrangedSubviews: [
                makeButton("1번"),
                makeButton("2번"),
                makeButton("3번")
            ]
        ).then {
            $0.axis = .horizontal
            $0.spacing = 20
        }

        let secondRow = UIStackView(
            arrangedSubviews: [
                makeButton("4번"),
                makeButton("5번"),
                makeButton("6번")
            ]
        ).then {
            $0.axis = .horizontal
            $0.spacing = 20
        }

        let thirdRow = UIStackView(
            arrangedSubviews: [
                makeButton("7번"),
                makeButton("8번"),
                makeButton("9번")
            ]
        ).then {
            $0.axis = .horizontal
            $0.spacing = 20
        }

        moreContainer.addSubview(moreButton)
        moreContainer.addSubview(moreTextField)

        addSubview(firstRow)
        addSubview(secondRow)
        addSubview(thirdRow)
        addSubview(moreContainer)

        firstRow.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.height.equalTo(24)
        }

        secondRow.snp.makeConstraints {
            $0.top.equalTo(firstRow.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.height.equalTo(24)
        }

        thirdRow.snp.makeConstraints {
            $0.top.equalTo(secondRow.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.height.equalTo(24)
        }

        countButtons.forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(107)
                $0.height.equalTo(24)
            }
        }

        moreContainer.snp.makeConstraints {
            $0.top.equalTo(thirdRow.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(24)
            $0.bottom.equalToSuperview()
        }

        moreButton.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(107)
        }

        moreTextField.snp.makeConstraints {
            $0.leading.equalTo(moreButton.snp.trailing).offset(8)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
    }

    private func setupLayout() {

        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.equalTo(40)
        }
    }

    private func setupAction() {

        moreButton.addTarget(
            self,
            action: #selector(countTapped(_:)),
            for: .touchUpInside
        )
    }

    @objc private func countTapped(_ sender: UIButton) {

        countButtons.forEach {
            $0.backgroundColor = UIColor(named: "main300")
            $0.setTitleColor(
                UIColor(named: "main800"),
                for: .normal
            )
        }

        moreButton.backgroundColor = UIColor(named: "main300")
        moreButton.setTitleColor(
            UIColor(named: "main800"),
            for: .normal
        )

        sender.backgroundColor = UIColor(named: "main600")
        sender.setTitleColor(.white, for: .normal)

        if sender == moreButton {
            moreButton.backgroundColor = UIColor(named: "main600")
            moreButton.setTitleColor(.white, for: .normal)
        }
    }
}

import UIKit
import SnapKit
import Then

final class CategoryView: UIView {
    var onCategorySelected: (() -> Void)?

    private let titleLabel = UILabel().then {
        $0.text = "카테고리"
        $0.font = .systemFont(ofSize: 25, weight: .semibold)
        $0.textColor = UIColor(named: "gray900")
    }

    private var categoryButtons: [UIButton] = []

    private let etcButton = UIButton(type: .system).then {
            $0.setTitle("기타", for: .normal)
            $0.setTitleColor(UIColor(named: "main800"), for: .normal)
            $0.backgroundColor = UIColor(named: "main300")
            $0.layer.cornerRadius = 15
            $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        }

    private let etcTextField = UITextField().then {
        $0.placeholder = "카테고리 입력"
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = UIColor(named: "gray900")
        $0.backgroundColor = UIColor(named: "main300")
    }

    private let etcContainer = UIView().then {
        $0.backgroundColor = UIColor(named: "main300")
        $0.layer.cornerRadius = 15
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
        let button = UIButton(type: .system).then {
            $0.setTitle(title, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
            $0.layer.cornerRadius = 15
            $0.backgroundColor = UIColor(named: "main300")
            $0.setTitleColor(
                UIColor(named: "main800"),
                for: .normal
            )
        }

        button.addTarget(
            self,
            action: #selector(categoryTapped(_:)),
            for: .touchUpInside
        )

        categoryButtons.append(button)

        return button
    }

    private func setupUI() {

        addSubview(titleLabel)

        let firstRow = UIStackView(
            arrangedSubviews: [
                makeButton("생활"),
                makeButton("운동"),
                makeButton("공부")
            ]
        ).then {
            $0.axis = .horizontal
            $0.spacing = 20
        }

        let secondRow = UIStackView(
            arrangedSubviews: [
                makeButton("식습관"),
                makeButton("마음건강"),
                makeButton("재정관리")
            ]
        ).then {
            $0.axis = .horizontal
            $0.spacing = 20
        }

        let cleaningButton = makeButton("청결")

        etcContainer.addSubview(etcButton)
        etcContainer.addSubview(etcTextField)

        addSubview(firstRow)
        addSubview(secondRow)
        addSubview(cleaningButton)
        addSubview(etcContainer)

        firstRow.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(19)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }

        secondRow.snp.makeConstraints {
            $0.top.equalTo(firstRow.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }

        // 청결 108 x 44
        cleaningButton.snp.makeConstraints {
            $0.top.equalTo(secondRow.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(24)
            $0.width.equalTo(108)
            $0.height.equalTo(44)
        }

        // 기타 + 입력창
        etcContainer.snp.makeConstraints {
            $0.top.equalTo(cleaningButton)
            $0.leading.equalTo(cleaningButton.snp.trailing).offset(16)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(44)
        }

        categoryButtons.forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(108)
                $0.height.equalTo(44)
            }
        }

        etcButton.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(108)
        }

        etcTextField.snp.makeConstraints {
            $0.leading.equalTo(etcButton.snp.trailing).offset(8)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()
        }
    }

    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
    }

    private func setupAction() {
        etcButton.addTarget(
            self,
            action: #selector(categoryTapped(_:)),
            for: .touchUpInside
        )
    }

    @objc private func categoryTapped(_ sender: UIButton) {

        categoryButtons.forEach {
            $0.backgroundColor = UIColor(named: "main300")
            $0.setTitleColor(
                UIColor(named: "main800"),
                for: .normal
            )
        }

        etcButton.backgroundColor = UIColor(named: "main300")
        etcButton.setTitleColor(
            UIColor(named: "main800"),
            for: .normal
        )

        sender.backgroundColor = UIColor(named: "main600")
        sender.setTitleColor(.white, for: .normal)

        onCategorySelected?()
    }
}

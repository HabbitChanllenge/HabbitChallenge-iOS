import UIKit
import SnapKit
import Then

final class CategoryView: UIView {
    var onCategorySelected: (() -> Void)?
    private(set) var selectedCategory: String?

    private let titleLabel = UILabel().then {
        $0.text = "카테고리"
        $0.font = .systemFont(ofSize: 25, weight: .semibold)
        $0.textColor = UIColor(named: "gray900")
    }

    private var categoryButtons: [UIButton] = []
    private let etcButton = UIButton(type: .system).then {
        $0.setTitle("기타", for: .normal)
        $0.layer.cornerRadius = 15
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
    }
    private let etcTextField = UITextField().then {
        $0.placeholder = "카테고리 입력"
        $0.font = .systemFont(ofSize: 12)
        $0.backgroundColor = UIColor(named: "main300")
        $0.addTarget(self, action: #selector(etcTextFieldDidChange), for: .editingChanged)
    }
    private let etcContainer = UIView().then {
        $0.backgroundColor = UIColor(named: "main300")
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupAction()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(category: String) {
        selectedCategory = category
        if let button = categoryButtons.first(where: { $0.currentTitle == category }) {
            applySelection(button)
        } else {
            etcTextField.text = category
            applySelection(etcButton)
        }
    }

    private func makeButton(_ title: String) -> UIButton {
        let button = UIButton(type: .system).then {
            $0.setTitle(title, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
            $0.layer.cornerRadius = 15
        }
        button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
        categoryButtons.append(button)
        return button
    }

    private func setupUI() {
        addSubview(titleLabel)
        let firstRow = UIStackView(arrangedSubviews: [makeButton("생활"), makeButton("운동"), makeButton("공부")]).then {
            $0.axis = .horizontal; $0.spacing = 20
        }
        let secondRow = UIStackView(arrangedSubviews: [makeButton("식습관"), makeButton("마음건강"), makeButton("재정관리")]).then {
            $0.axis = .horizontal; $0.spacing = 20
        }
        let cleaningButton = makeButton("청결")
        etcContainer.addSubview(etcButton)
        etcContainer.addSubview(etcTextField)
        [firstRow, secondRow, cleaningButton, etcContainer].forEach(addSubview)

        titleLabel.snp.makeConstraints { $0.top.equalToSuperview(); $0.leading.equalToSuperview().inset(24); $0.height.equalTo(40) }
        firstRow.snp.makeConstraints { $0.top.equalTo(titleLabel.snp.bottom).offset(19); $0.leading.trailing.equalToSuperview().inset(24); $0.height.equalTo(44) }
        secondRow.snp.makeConstraints { $0.top.equalTo(firstRow.snp.bottom).offset(16); $0.leading.trailing.equalToSuperview().inset(24); $0.height.equalTo(44) }
        cleaningButton.snp.makeConstraints { $0.top.equalTo(secondRow.snp.bottom).offset(16); $0.leading.equalToSuperview().inset(24); $0.width.equalTo(108); $0.height.equalTo(44) }
        etcContainer.snp.makeConstraints { $0.top.equalTo(cleaningButton); $0.leading.equalTo(cleaningButton.snp.trailing).offset(16); $0.trailing.equalToSuperview().inset(24); $0.height.equalTo(44); $0.bottom.equalToSuperview() }
        categoryButtons.forEach { $0.snp.makeConstraints { $0.width.equalTo(108); $0.height.equalTo(44) } }
        etcButton.snp.makeConstraints { $0.top.leading.bottom.equalToSuperview(); $0.width.equalTo(108) }
        etcTextField.snp.makeConstraints { $0.leading.equalTo(etcButton.snp.trailing).offset(8); $0.top.bottom.equalToSuperview(); $0.trailing.equalToSuperview().inset(10) }
        resetAppearance()
    }

    private func setupAction() {
        etcButton.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
    }

    private func resetAppearance() {
        (categoryButtons + [etcButton]).forEach {
            $0.backgroundColor = UIColor(named: "main300")
            $0.setTitleColor(UIColor(named: "main800"), for: .normal)
        }
    }

    private func applySelection(_ button: UIButton) {
        resetAppearance()
        button.backgroundColor = UIColor(named: "main600")
        button.setTitleColor(.white, for: .normal)
    }

    @objc private func categoryTapped(_ sender: UIButton) {
        let category = sender == etcButton ? (etcTextField.text ?? "") : (sender.currentTitle ?? "")
        selectedCategory = category
        HabitManager.shared.category = category
        applySelection(sender)
        onCategorySelected?()
    }

    @objc private func etcTextFieldDidChange() {
        guard etcButton.backgroundColor == UIColor(named: "main600") else { return }
        selectedCategory = etcTextField.text ?? ""
        HabitManager.shared.category = selectedCategory
    }
}

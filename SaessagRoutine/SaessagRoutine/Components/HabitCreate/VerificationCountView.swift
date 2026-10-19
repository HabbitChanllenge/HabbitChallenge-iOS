import UIKit
import SnapKit
import Then

final class VerificationCountView: UIView {
    var onCountSelected: (() -> Void)?
    private(set) var selectedCount: Int?

    private let titleLabel = UILabel().then {
        $0.text = "주기당 인증횟수"
        $0.font = .systemFont(ofSize: 25, weight: .semibold)
        $0.textColor = UIColor(named: "gray900")
    }

    var countButtons: [UIButton] = []
    private let moreButton = UIButton(type: .system).then {
        $0.setTitle("그 이상", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        $0.layer.cornerRadius = 15
    }
    private let moreTextField = UITextField().then {
        $0.placeholder = "숫자로만 입력해 주세요. 예) 12"
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.keyboardType = .numberPad
        $0.addTarget(self, action: #selector(countEditingChanged), for: .editingChanged)
    }
    private let moreContainer = UIView().then {
        $0.backgroundColor = UIColor(named: "main300")
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(count: Int?) {
        selectedCount = count
        resetAppearance()
        guard let count else { return }
        if let button = countButtons.first(where: { $0.currentTitle == "\(count)번" }) {
            applySelection(button)
        } else {
            moreTextField.text = String(count)
            applySelection(moreButton)
        }
    }

    private func makeButton(_ title: String) -> UIButton {
        let button = UIButton(type: .system).then {
            $0.setTitle(title, for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
            $0.layer.cornerRadius = 15
        }
        button.addTarget(self, action: #selector(countTapped(_:)), for: .touchUpInside)
        countButtons.append(button)
        return button
    }

    private func setupUI() {
        addSubview(titleLabel)
        let firstRow = UIStackView(arrangedSubviews: [makeButton("1번"), makeButton("2번"), makeButton("3번")]).then { $0.axis = .horizontal; $0.spacing = 16 }
        let secondRow = UIStackView(arrangedSubviews: [makeButton("4번"), makeButton("5번"), makeButton("6번")]).then { $0.axis = .horizontal; $0.spacing = 16 }
        let thirdRow = UIStackView(arrangedSubviews: [makeButton("7번"), makeButton("8번"), makeButton("9번")]).then { $0.axis = .horizontal; $0.spacing = 16 }
        moreContainer.addSubview(moreButton)
        moreContainer.addSubview(moreTextField)
        [firstRow, secondRow, thirdRow, moreContainer].forEach(addSubview)

        titleLabel.snp.makeConstraints { $0.top.equalToSuperview(); $0.leading.equalToSuperview().inset(24) }
        firstRow.snp.makeConstraints { $0.top.equalTo(titleLabel.snp.bottom).offset(19); $0.leading.trailing.equalToSuperview().inset(24); $0.height.equalTo(44) }
        secondRow.snp.makeConstraints { $0.top.equalTo(firstRow.snp.bottom).offset(16); $0.leading.trailing.equalToSuperview().inset(24); $0.height.equalTo(44) }
        thirdRow.snp.makeConstraints { $0.top.equalTo(secondRow.snp.bottom).offset(16); $0.leading.trailing.equalToSuperview().inset(24); $0.height.equalTo(44) }
        countButtons.forEach { $0.snp.makeConstraints { $0.width.equalTo(108); $0.height.equalTo(44) } }
        moreContainer.snp.makeConstraints { $0.top.equalTo(thirdRow.snp.bottom).offset(16); $0.leading.trailing.equalToSuperview().inset(24); $0.height.equalTo(44); $0.bottom.equalToSuperview() }
        moreButton.snp.makeConstraints { $0.top.leading.bottom.equalToSuperview(); $0.width.equalTo(108) }
        moreTextField.snp.makeConstraints { $0.leading.equalTo(moreButton.snp.trailing).offset(8); $0.top.bottom.equalToSuperview(); $0.trailing.equalToSuperview().inset(10) }
        resetAppearance()
    }

    private func resetAppearance() {
        (countButtons + [moreButton]).forEach {
            $0.backgroundColor = UIColor(named: "main300")
            $0.setTitleColor(UIColor(named: "main800"), for: .normal)
        }
    }

    private func applySelection(_ button: UIButton) {
        resetAppearance()
        button.backgroundColor = UIColor(named: "main600")
        button.setTitleColor(.white, for: .normal)
    }

    @objc private func countTapped(_ sender: UIButton) {
        let count: Int
        if sender == moreButton {
            count = Int(moreTextField.text ?? "") ?? 0
        } else {
            count = Int(sender.currentTitle?.replacingOccurrences(of: "번", with: "") ?? "") ?? 0
        }
        selectedCount = count
        HabitManager.shared.repeatCount = count
        applySelection(sender)
        onCountSelected?()
    }

    @objc private func countEditingChanged() {
        guard moreButton.backgroundColor == UIColor(named: "main600") else { return }
        selectedCount = Int(moreTextField.text ?? "")
        HabitManager.shared.repeatCount = selectedCount
    }
}

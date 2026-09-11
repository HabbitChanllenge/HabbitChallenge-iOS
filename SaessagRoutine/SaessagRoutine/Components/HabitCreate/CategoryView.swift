import UIKit
import SnapKit
import Then

final class CategoryView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.text = "카테고리"
        $0.font = .systemFont(ofSize: 32, weight: .bold)
        $0.textColor = UIColor(named: "gray900")
    }
    
    private var categoryButtons: [UIButton] = []
    
    private let etcButton = UIButton().then {
        $0.setTitle("기타", for: .normal)
        $0.setTitleColor(UIColor(named: "main800"), for: .normal)
        $0.backgroundColor = UIColor(named: "main300")
        $0.layer.cornerRadius = 12
        $0.titleLabel?.font = .systemFont(ofSize: 12)
    }
    
    private let etcTextField = UITextField().then {
        $0.placeholder = "카테고리를 입력해 주세요."
        $0.font = .systemFont(ofSize: 9)
        $0.textColor = UIColor(named: "main800")
        $0.backgroundColor = UIColor(named: "main300")
        $0.borderStyle = .none
    }
    
    private let etcContainer = UIView().then {
        $0.backgroundColor = UIColor(named: "main300")
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
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
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        secondRow.snp.makeConstraints {
            $0.top.equalTo(firstRow.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        cleaningButton.snp.makeConstraints {
            $0.top.equalTo(secondRow.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.width.equalTo(107)
            $0.height.equalTo(24)
        }
        
        etcContainer.snp.makeConstraints {
            $0.top.equalTo(secondRow.snp.bottom).offset(10)
            $0.leading.equalTo(cleaningButton.snp.trailing).offset(20)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        categoryButtons.forEach {
            $0.snp.makeConstraints {
                $0.width.equalTo(107)
                $0.height.equalTo(24)
            }
        }
        
        etcButton.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(107)
        }
        
        etcTextField.snp.makeConstraints {
            $0.leading.equalTo(etcButton.snp.trailing).offset(8)
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
        etcButton.addTarget(
            self,
            action: #selector(categoryTapped(_:)),
            for: .touchUpInside
        )
    }
    
    private func setupLayout() {
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.equalTo(40)
        }
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
    }
}

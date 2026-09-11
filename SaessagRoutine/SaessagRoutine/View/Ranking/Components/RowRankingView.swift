import UIKit
import SnapKit
import Then

final class RowRankingView: UIView {
    
    private let rank: Int
    
    private let rankLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.textAlignment = .center
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.textAlignment = .center
    }
    
    private let dayLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .regular)
        $0.textColor = UIColor(named: "main900")
        $0.textAlignment = .right
    }
    
    init(rank: Int, name: String, days: Int) {
        self.rank = rank
        
        super.init(frame: .zero)
        
        rankLabel.text = "\(rank)"
        nameLabel.text = name
        dayLabel.text = "\(days)일"
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(rankLabel)
        addSubview(nameLabel)
        addSubview(dayLabel)
        
        layer.cornerRadius = 20
        clipsToBounds = true
        
        if rank % 2 == 0 {
            backgroundColor = UIColor(named: "main100")
        } else {
            backgroundColor = .white
            layer.borderWidth = 1
            layer.borderColor = UIColor.black.cgColor
        }
    }
    
    private func setupLayout() {
        rankLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(30)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(113)
            $0.centerY.equalToSuperview()
        }
        
        dayLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
        
        self.snp.makeConstraints {
            $0.height.equalTo(63)
        }
    }
    
    func configure(rank: Int, name: String, days: Int) {
        rankLabel.text = "\(rank)"
        nameLabel.text = name
        dayLabel.text = "\(days)일"
    }
}

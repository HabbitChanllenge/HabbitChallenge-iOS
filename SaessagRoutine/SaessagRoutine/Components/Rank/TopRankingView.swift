import UIKit
import SnapKit
import Then

final class TopRankingView: UIView {
    
    private let firstNameLabel = UILabel().then {
        $0.text = "seoyun_1444"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textAlignment = .center
    }

    private let firstDayLabel = UILabel().then {
        $0.text = "365일"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textColor = UIColor(named: "main900")
        $0.textAlignment = .center
    }

    private let secondNameLabel = UILabel().then {
        $0.text = "seoyun_2444"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textAlignment = .center
    }

    private let secondDayLabel = UILabel().then {
        $0.text = "277일"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textColor = UIColor(named: "main900")
        $0.textAlignment = .center
    }

    private let thirdNameLabel = UILabel().then {
        $0.text = "seoyun_3444"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textAlignment = .center
    }

    private let thirdDayLabel = UILabel().then {
        $0.text = "244일"
        $0.font = .systemFont(ofSize: 15, weight: .bold)
        $0.textColor = UIColor(named: "main900")
        $0.textAlignment = .center
    }
    
    private let firstRankView = UIView().then {
        $0.backgroundColor = UIColor(named: "main400")
        $0.layer.cornerRadius = 20
    }
    
    private let secondRankView = UIView().then {
        $0.backgroundColor = UIColor(named: "main600")
        $0.layer.cornerRadius = 20
    }
    
    private let thirdRankView = UIView().then {
        $0.backgroundColor = UIColor(named: "main700")
        $0.layer.cornerRadius = 20
    }
    
    private let trophyImageView = UIImageView().then {
        $0.image = UIImage(systemName: "trophy.fill")
        $0.tintColor = UIColor(named: "gold")
        $0.contentMode = .scaleAspectFit
    }
    
    private let firstInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }
    
    private let secondInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }
    
    private let thirdInfoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }
    
    private let firstColumnStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }
    
    private let secondColumnStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }
    
    private let thirdColumnStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }
    
    private let podiumStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .bottom
        $0.distribution = .fill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(podiumStackView)
        
        firstInfoStackView.addArrangedSubview(firstNameLabel)
        firstInfoStackView.addArrangedSubview(firstDayLabel)
        
        secondInfoStackView.addArrangedSubview(secondNameLabel)
        secondInfoStackView.addArrangedSubview(secondDayLabel)
        
        thirdInfoStackView.addArrangedSubview(thirdNameLabel)
        thirdInfoStackView.addArrangedSubview(thirdDayLabel)
        
        firstRankView.addSubview(trophyImageView)
        
        firstColumnStackView.addArrangedSubview(firstInfoStackView)
        firstColumnStackView.addArrangedSubview(firstRankView)
        
        secondColumnStackView.addArrangedSubview(secondInfoStackView)
        secondColumnStackView.addArrangedSubview(secondRankView)
        
        thirdColumnStackView.addArrangedSubview(thirdInfoStackView)
        thirdColumnStackView.addArrangedSubview(thirdRankView)
        
        podiumStackView.addArrangedSubview(secondColumnStackView)
        podiumStackView.addArrangedSubview(firstColumnStackView)
        podiumStackView.addArrangedSubview(thirdColumnStackView)
    }
    
    private func setupLayout() {
        podiumStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        firstRankView.snp.makeConstraints {
            $0.width.equalTo(97)
            $0.height.equalTo(136)
        }
        
        secondRankView.snp.makeConstraints {
            $0.width.equalTo(97)
            $0.height.equalTo(92)
        }
        
        thirdRankView.snp.makeConstraints {
            $0.width.equalTo(97)
            $0.height.equalTo(72)
        }
        
        trophyImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(25)
        }
    }
    
    func configure(
        firstName: String,
        firstDays: Int,
        secondName: String,
        secondDays: Int,
        thirdName: String,
        thirdDays: Int
    ) {
        firstNameLabel.text = firstName
        firstDayLabel.text = "\(firstDays)일"
        
        secondNameLabel.text = secondName
        secondDayLabel.text = "\(secondDays)일"
        
        thirdNameLabel.text = thirdName
        thirdDayLabel.text = "\(thirdDays)일"
    }
}

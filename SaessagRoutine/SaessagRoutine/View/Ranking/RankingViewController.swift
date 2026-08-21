import UIKit
import SnapKit
import Then
import Moya

class RankingViewController: UIViewController {
    
    let navBar = NavigationBarView(streak: "31")
    private let topRankingView = TopRankingView()
    
    private let scrollView = UIScrollView()
    
    private let rankingStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setRanking()
    }
    
    private func setLayout() {
        view.addSubview(topRankingView)
        view.addSubview(scrollView)
        view.addSubview(navBar)

        scrollView.addSubview(rankingStackView)

        navBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(108)
        }

        topRankingView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(-30)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(260)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(topRankingView.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        rankingStackView.snp.makeConstraints {
            $0.top.bottom.equalTo(scrollView.contentLayoutGuide)
            $0.leading.trailing.equalTo(scrollView.frameLayoutGuide).inset(22)
        }
        
        view.bringSubviewToFront(navBar)
    }
    
    private func setRanking() {
        for rank in 4...20 {
            let row = RowRankingView(
                rank: rank,
                name: "taegyun\(rank)",
                days: 230 - rank
            )
            
            rankingStackView.addArrangedSubview(row)
        }
    }
}

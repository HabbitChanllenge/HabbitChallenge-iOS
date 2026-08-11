import UIKit
import SnapKit
import Then
import Moya

class RankingViewController: UIViewController {
    
    let navBar = NavigationBarView(streak: "31")
    private let topRankingView = TopRankingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    private func setLayout() {
        view.addSubview(navBar)
        view.addSubview(topRankingView)
        
        navBar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(108)
        }
        
        topRankingView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

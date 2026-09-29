//
//  StreakAPI.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 9/4/26.
//

import Foundation
import Moya
import Alamofire

enum StreakAPI {
    case getStreak
    case getRank
}
extension StreakAPI: TargetType {
    var baseURL: URL {
        Secrets.baseURL
    }
    
    var path: String {
        switch self {
        case .getStreak:
            return "/streak/allStreak"
        case .getRank:
            return "/streak/rank"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return ["Authorization": "Bearer \(TokenManager.shared.token)"]
    }
}

struct Streak : Codable{//스트릭 보기 시 사용
    let allStreak: Int
}
struct Rank: Codable {//랭킹보기 시 사용
    let status : Int
    let data : [RankData]?
}
struct RankData: Codable {//랭킹 보기 시 사용
    let rank : Int
    let name : String
    let streak: Int
}

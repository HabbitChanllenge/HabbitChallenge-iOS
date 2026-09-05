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
        return nil
    }
}

struct Streak {
    let streak: Int
}
struct Rank: Codable {
    let status : Int
    let data : [RankData]
    let user : [RankData]
}
struct RankData: Codable {
    let rank : Int
    let name : String
    let streak: Int
}


//
//  UserAPI.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 9/4/26.
//

import Foundation
import Moya
import Alamofire

enum UserAPI {
    case getUserInfo
    case patchUserInfo(userId:String, email:String, password:String)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        Secrets.baseURL
    }
    
    var path: String {
        return "/user/me"
    }
    
    var method: Moya.Method {
        switch self {
        case .getUserInfo:
            return .get
        case .patchUserInfo:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUserInfo:
            return .requestPlain
        case .patchUserInfo:
            return .requestParameters(parameters: [:], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
struct getMypageInfo: Codable, Equatable {
    let userId : String
    let email : String
    let password : String
    let statusCode : Int
}
struct patchMypageInfo: Codable, Equatable {
    let status : Int?
    let message : String
}

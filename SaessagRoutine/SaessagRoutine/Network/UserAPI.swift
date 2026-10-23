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
    case patchUserInfo(userId:String, email:String)
    case changePassword(oldPassword:String, newPassword:String)
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
        case .patchUserInfo, .changePassword:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getUserInfo:
            return .requestPlain
        case .patchUserInfo(let userId, let email):
            let param : [String: String] = ["userId": userId, "email": email]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .changePassword(let oldPassword, let newPassword):
            let param : [String: String] = ["currentPassword": oldPassword, "newPassword": newPassword]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Authorization": "Bearer \(TokenManager.shared.token)"]
    }
}
struct getMypageInfo: Codable, Equatable {//마이페이지 조회 시 사용
    let userId : Int
    let name : String
    let email : String
    let statusCode : Int
}
struct patchMypageInfo: Codable, Equatable {// 마이페이지 수정시 사용
    let type : String?
    let statusCode : Int?
    let message : String
}

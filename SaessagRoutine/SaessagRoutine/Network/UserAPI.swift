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
    case getUserInfo(token:String)
    case patchUserInfo(token:String, userId:String, email:String, password:String)
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
        case .patchUserInfo(_, let userId, let email, let password):
            let param : [String: String] = ["userId": userId, "email": email, "password": password]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getUserInfo(let token):
            let header = ["Authorization": "Bearer \(token)"]
            return header
        case .patchUserInfo(let token, _, _, _):
            let header = ["Authorization": "Bearer \(token)"]
            return header
        }
    }
}
struct getMypageInfo: Codable, Equatable {//마이페이지 조회 시 사용
    let userId : String
    let email : String
    let password : String
    let statusCode : Int
}
struct patchMypageInfo: Codable, Equatable {// 마이페이지 수정시 사용
    let status : Int?
    let message : String
}

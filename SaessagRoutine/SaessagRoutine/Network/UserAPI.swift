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
    case patchUserInfo(token:String, userId:String, email:String)
    case changePassword(token:String, oldPassword:String, newPassword:String)
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
        case .patchUserInfo(_, let userId, let email):
            let param : [String: String] = ["userId": userId, "email": email]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .changePassword(_ , let oldPassword, let newPassword):
            let param : [String: String] = ["currentPassword": oldPassword, "newPassword": newPassword]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getUserInfo(let token):
            let header = ["Authorization": "Bearer \(token)"]
            return header
        case .patchUserInfo(let token, _, _):
            let header = ["Authorization": "Bearer \(token)"]
            return header
        case .changePassword(token: let token, oldPassword: let oldPassword, newPassword: let newPassword):
            let header = ["Authorization": "Bearer \(token)"]
            return header
        }
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

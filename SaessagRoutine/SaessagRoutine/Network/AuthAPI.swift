//
//  AuthAPI.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 9/4/26.
//

import Foundation
import Moya
import Alamofire

enum AuthAPI {
    case login(email: String, password: String)
    case signup(userId: String, email: String, password: String)
    case logout
    case resign
}
extension AuthAPI: TargetType {
    var baseURL: URL {
        Secrets.baseURL
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .signup:
            return "/signup"
        case .logout:
            return "/logout"
        case .resign:
            return "/resign"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .signup, .logout:
            return .post
        case .resign:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let email, let password):
            let param: [String: Any] = ["email" : email, "password" : password]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .signup(userId: let userId, email: let email, password: let password):
            let param: [String: Any] = ["userId" : userId, "email" : email, "password" : password]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .logout, .resign:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}

struct loginResponse : Codable, Equatable {//로그인 시 사용
    let accessToken : String
    let tokenType : String
    let statusCode : Int
}
struct authResponse : Codable, Equatable {//회원가입, 로그아웃, 탈퇴시 사용
    let type : String
    let statusCode : Int
}

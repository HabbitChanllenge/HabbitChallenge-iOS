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
    case logout(token: String)
    case resign(token: String, password: String)
    case checkEmail(email:String)
    case checkVerifyCode(email:String, code:String)
    case changePassword(email : String, newPassword : String)
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
        case .checkEmail:
            return "/password-reset/email"
        case .checkVerifyCode:
            return "/password-reset/verify"
        case .changePassword:
            return "/password-reset"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .signup, .logout, .checkEmail, .checkVerifyCode:
            return .post
        case .resign:
            return .delete
        case .changePassword:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .login(let email, let password):
            let param: [String: String] = ["email" : email, "password" : password]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .signup(let userId, let email, let password):
            let param: [String: String] = ["userId" : userId, "email" : email, "password" : password]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .logout:
            return .requestPlain
        case .resign(_, let password):
            let param: [String: String] = ["password" : password]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .checkEmail(let email):
            let param: [String: String] = ["email" : email]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .checkVerifyCode(let email, let code):
            let param: [String: String] = ["email" : email, "code" : code]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        case .changePassword(let email, let newPassword):
            let param: [String: String] = ["email" : email, "newPassword" : newPassword]
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .logout(let token), .resign(let token, _):
            return ["Authorization": "Bearer \(token)"]
        default :
            return nil
        }
    }
}

struct loginResponse : Codable, Equatable {//로그인 시 사용
    let accessToken : String?
    let tokenType : String?
    let type : String?
    let statusCode : Int
}
struct signUpResponse : Codable, Equatable {//회원가입 시 사용
    let type : String
    let statusCode : Int
}
struct authResponse : Codable, Equatable {//로그아웃, 회원 탈퇴, 인증번호 발송, 인증코드 확인, 비밀번호 수정 시 사용
    let message : String?
    let type : String?
    let statusCode : Int
}


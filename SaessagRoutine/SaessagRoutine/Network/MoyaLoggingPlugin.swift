//
//  MoyaLogging.swift
//  SaessagRoutine
//
//  Created by Seoyun Jin on 9/4/26.
//

import Foundation
import Moya

final class MoyaLoggingPlugin: PluginType {
    
    // 요청 보낼 때 호출
    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            print("❌ 요청 실패")
            return
        }
        
        let url = httpRequest.url?.absoluteString ?? "알 수 없는 URL"
        let method = httpRequest.httpMethod ?? "UNKNOWN"
        
        var log = """
        ----------------------------------------------------
        🚀 [HTTP Request]
        URL: \(url)
        Method: \(method)
        """
        
        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            log.append("\nHeaders: \(headers)")
        }
        
        if let body = httpRequest.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            log.append("\nBody: \(bodyString)")
        }
        
        log.append("\n----------------------------------------------------")
        print(log)
    }
    
    // Response 받았을 때 호출
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            onSucess(response, target: target)
        case .failure(let error):
            onFailure(error, target: target)
        }
    }
    
    // 성공 시
    private func onSucess(_ response: Response, target: TargetType) {
        let statusCode = response.statusCode
        var log = """
        ----------------------------------------------------
        ✅ [HTTP Response]
        Target: \(target)
        Status Code: \(statusCode)
        """
        
        // JSON 형태의 응답 본문 출력
        if let responseString = String(data: response.data, encoding: .utf8) {
            log.append("\nResponse Body:\n\(responseString)")
        }
        
        log.append("\n----------------------------------------------------")
        print(log)
    }
    
    // 에러 시
    private func onFailure(_ error: MoyaError, target: TargetType) {
        var log = """
        ----------------------------------------------------
        ❌ [HTTP Error]
        Target: \(target)
        Error Code: \(error.errorCode)
        Description: \(error.localizedDescription)
        """
        
        // 서버에서 전달해준 에러 바디가 있다면 출력
        if let response = error.response, let responseString = String(data: response.data, encoding: .utf8) {
            log.append("\nError Body:\n\(responseString)")
        }
        
        log.append("\n----------------------------------------------------")
        print(log)
    }
}

//
//  EYunApi.swift
//  SHMoyaNetwork
//
//  Created by YYKJ on 2021/10/12.
//

import Foundation
import Moya

let source = TokenSource()
let uuid = UUID().uuidString
let eyunProvider = MoyaProvider<EYun>(plugins: [loggerPlugin,
                                                AuthPlugin(tokenClosure: { source.token })
                                               ])

public enum EYun {
    case login(String, String, String)
    case userInfo(String)
    case graphicCode(String)
}

extension EYun: AuthorizedTargetType {
    
    public var needsAuth: Bool {
        switch self {
        case .login(_, _, _):
            return false
        case .graphicCode(_):
            return false
        default:
            return true
        }
    }
    
    // 基于公司测试服务器: http://192.168.5.167:8400
    public var baseURL: URL {
        URL(string: "https://api-fcsp.zgyiyun.com:1200")!
    }
    
    public var path: String {
        switch self {
        case .login(_, _, _):
            return "/Authorization/Token/LoginAsync"
        case .userInfo(_):
            return "/User/UserManage/GetUserInfo"
        case .graphicCode(_):
            return "User/UserManage/GetVerificationCode"
        }
    }
    
    public var method: Moya.Method { .post }
    
    public var task: Task {
        switch self {
        case .login(let account, let password, let code):
            return .requestParameters(parameters: ["account": account,
                                                   "password": password,
                                                   "vcode":  code,
                                                   "uuid": uuid,
                                                   "token": ""], encoding: JSONEncoding.default)
            
        case .userInfo(_):
            return .requestPlain
            
        case .graphicCode(let uuid):
            return .requestParameters(parameters: ["uuid": uuid], encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
//        return nil
//        return ["Twi_Client": "app"]
        
        switch self {
        case .login(_, _, _):
            return ["Twi_Client": "app", "Content-Type": "application/json-patch+json"]
        default:
            return ["Twi_Client": "app"]
        }
    }
    
    
}

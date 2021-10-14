//
//  Api.swift
//  SHMoyaNetwork
//
//  Created by YYKJ on 2021/10/12.
//

import Foundation
import Moya

// V2EX 开放接口
// https://www.v2ex.com/api/topics/hot.json
// https://www.v2ex.com/api/topics/latest.json
// https://www.v2ex.com/api/nodes/show.json
// https://www.v2ex.com/api/members/show.json

public func JSONResponseDataFormatter(_ data: Data) -> String {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
    } catch {
        return String(data: data, encoding: .utf8) ?? ""
    }
}

public let loggerPlugin = NetworkLoggerPlugin(configuration: .init(formatter: .init(responseData: JSONResponseDataFormatter), logOptions: .verbose))

let V2EXProvider = MoyaProvider<V2EX>(plugins: [loggerPlugin])

public enum V2EX {
    case hot
    case latest
    case nodesShow(String)
    case membersShow(String)
}

extension V2EX: TargetType {
    public var baseURL: URL { URL(string: "https://www.v2ex.com/api")! }

    public var path: String {
        switch self {
        case .hot:
            return "/topics/hot.json"
        case .latest:
            return "/topics/latest.json"
        case .nodesShow(let node):
            return "/nodes/show.json?name=\(node)"
        case .membersShow(let id):
            return "/members/show.json?id=\(id)"
        }
    }

    public var method: Moya.Method { .get }

    public var task: Task {
        .requestPlain
    }

    public var headers: [String : String]? {
        nil
    }
}

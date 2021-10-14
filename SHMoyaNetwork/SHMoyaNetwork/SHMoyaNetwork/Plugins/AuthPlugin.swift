//
//  AuthPlugin.swift
//  SHMoyaNetwork
//
//  Created by YYKJ on 2021/10/12.
//

import Foundation
import Moya

class TokenSource {
  var token: String?
  init() { }
}

protocol AuthorizedTargetType: TargetType {
  var needsAuth: Bool { get }
}

extension AuthorizedTargetType {
    var needsAuth: Bool {
        return false
    }
}

struct AuthPlugin: PluginType {
  let tokenClosure: () -> String?

  func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
    guard
      let token = tokenClosure(),
      let target = target as? AuthorizedTargetType,
      target.needsAuth
    else {
      return request
    }

    var request = request
    request.addValue(token, forHTTPHeaderField: "TwiAuth")
    return request
  }
}

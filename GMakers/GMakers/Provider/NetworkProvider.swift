//
//  NetworkProvider.swift
//  GMakers
//
//  Created by Lee on 2021/08/14.
//

import Foundation

class NetworkProvider {
  
  enum Path {
    case signup
    case signin
    
    var path: String {
      switch self {
      case .signup:
        return "/api/accounts/sign-up"
        
      case .signin:
        return "/api/accounts/sign-in"
      }
    }
  }
  
  
  private let base = "http://52.79.197.237:8080"
  private let path: Path
  
  init(path: Path) {
    self.path = path
  }
  
  func sign(id: String, password: String, completion: @escaping (Result<Data, Error>) -> Void) {
    guard
      let url = URL(string: self.base + path.path)
    else {
      completion(.failure(NSError(domain: "URL missing", code: 0)))
      return
    }
    
    let parameters = "{\"username\": \"\(id)\",\n  \"password\": \"\(password)\"}"
    let postData = parameters.data(using: .utf8)
    
    var request = URLRequest(url: url)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = postData
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard error == nil else {
        completion(.failure(error!))
        return
      }
      
      guard let data = data else {
        completion(.failure(NSError(domain: "data missing", code: 1)))
        return
      }
      
      guard let response = response as? HTTPURLResponse else { fatalError() }
      
      switch response.statusCode {
      case 200...300:
        completion(.success(data))
        
      case 4001:
        completion(.failure(NSError(domain: "존재하지 않는 회원", code: 2)))
        
      case 4003:
        completion(.failure(NSError(domain: "중복된 아이디", code: 3)))
        
      default:
        completion(.failure(NSError(domain: "회원가입 실패", code: 4)))
      }
    }

    task.resume()
  }
}

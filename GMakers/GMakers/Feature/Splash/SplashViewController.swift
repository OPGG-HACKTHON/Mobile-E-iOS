//
//  SplashViewController.swift
//  GMakers
//
//  Created by Lee on 2021/08/06.
//

import UIKit

import Alamofire

final class SplashViewController: BaseViewController {
  
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      switch UserDefaultsManager.token {
      case .some:
        switch UserDefaultsManager.tokenTime {
        case .some(let time):
          let now = Int(Date().timeIntervalSince1970)
          let hour23 = 23 * 60 * 60
          
          switch now - time > hour23 {
          case true: // 토큰 갱신
            self.requestToken()
            
          case false: // 진행
            WindowManager.set(.main)
          }
          
        case .none:
          self.requestToken()
        }
        
      case .none:
        WindowManager.set(.login)
      }
    }
  }
  
  private func requestToken() {
    let param = [
      "username": UserDefaultsManager.id!,
      "password": UserDefaultsManager.password!
    ]
    let headers: HTTPHeaders = ["Content-Type": "application/json"]
    
    AF.request("http://52.79.197.237:8080/api/accounts/sign-in",
               method: .post,
               parameters: param,
               encoding: JSONEncoding.default,
               headers: headers).responseJSON { response in
                switch response.result {
                case .failure:
                  self.alertBase(title: nil, message: "아이디와 비밀번호를 확인해주세요")
                  
                case .success(let data):
                  guard let temp = data as? [String: String], let token = temp["token"] else { return }
                  UserDefaultsManager.token = token
                  UserDefaultsManager.tokenTime = Int(Date().timeIntervalSince1970)
                  WindowManager.set(.main)
                }
               }
  }
  
  
  
  
  override func setAttribute() {
    self.imageView.image = UIImage(named: "Splash")
    self.imageView.contentMode = .scaleAspectFill
    
    self.titleLabel.text = "G-MAKERS"
    self.titleLabel.textColor = .white
    self.titleLabel.font = UIFont.Azonix.base(size: 40)
  }
  
  override func setConstraint() {
    [self.imageView, self.titleLabel].forEach {
      self.view.addSubview($0)
    }
    
    self.imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    self.titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}

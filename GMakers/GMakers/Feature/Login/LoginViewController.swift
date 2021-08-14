//
//  LoginViewController.swift
//  GMakers
//
//  Created by Lee on 2021/08/06.
//

import UIKit

import Alamofire

final class LoginViewController: BaseViewController {
  
  // MARK: - Property
  
  private let logoLabel = UILabel()
  private let idView = TextInputView()
  private let passwordView = TextInputView()
  private let loginButton = UIButton()
  private let signupButton = UIButton()
  
  
  
  // MARK: - Touch
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    
    self.view.endEditing(true)
  }
  
  
  
  // MARK: - Interface
  
  @objc private func loginDidTap(_ sender: UIButton) {
    guard
      let id = self.idView.textField.text, !id.isEmpty, !id.contains(" "),
      let password = self.passwordView.textField.text, !password.isEmpty
    else {
      self.alertBase(title: nil, message: "아이디와 비밀번호를 확인해주세요")
      return
    }
    
    self.view.endEditing(true)
    
    let param = ["username": id, "password": password]
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
                  WindowManager.set(.main)
                }
               }
    
  }
  
  @objc private func signupDidTap(_ sender: UIButton) {
    let vcSignup = SignupViewController()
    self.navigationController?.pushViewController(vcSignup, animated: true)
  }
  
  
  
  // MARK: - UI
  
  override func setNavigation() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.barTintColor = .white
  }
  
  override func setAttribute() {
    self.logoLabel.text = "G-MAKERS"
    self.logoLabel.font = UIFont.Azonix.base(size: 40)
    self.logoLabel.textColor = UIColor.my6540E9
    
    self.idView.titleLabel.text = "아이디"
    
    self.passwordView.titleLabel.text = "비밀번호"
    self.passwordView.textField.isSecureTextEntry = true
    
    self.loginButton.setTitle("로그인", for: .normal)
    self.loginButton.setTitleColor(.white, for: .normal)
    self.loginButton.backgroundColor = UIColor.my6540E9
    self.loginButton.titleLabel?.font = UIFont.NotoSansKR.bold(size: 14)
    self.loginButton.layer.cornerRadius = 4
    self.loginButton.addTarget(self, action: #selector(self.loginDidTap(_:)), for: .touchUpInside)
    
    self.signupButton.titleLabel?.font = UIFont.NotoSansKR.regular(size: 12)
    let attributedString = NSMutableAttributedString.create(text: "아직 계정이 없으신가요?   회원가입",
                                                            keyWord: "회원가입",
                                                            keyWordColor: UIColor.my6540E9)
    self.signupButton.setAttributedTitle(attributedString, for: .normal)
    self.signupButton.addTarget(self, action: #selector(self.signupDidTap(_:)), for: .touchUpInside)
  }
  
  override func setConstraint() {
    [self.logoLabel, self.idView, self.passwordView, self.loginButton, self.signupButton].forEach {
      self.view.addSubview($0)
    }
    
    self.logoLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(144)
    }
    
    self.idView.snp.makeConstraints { make in
      make.top.equalTo(self.logoLabel.snp.bottom).offset(60)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(62)
    }
    
    self.passwordView.snp.makeConstraints { make in
      make.top.equalTo(self.idView.snp.bottom).offset(24)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(62)
    }
    
    self.loginButton.snp.makeConstraints { make in
      make.top.equalTo(self.passwordView.snp.bottom).offset(32)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(54)
    }
    
    self.signupButton.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.loginButton.snp.bottom).offset(12)
    }
  }
}

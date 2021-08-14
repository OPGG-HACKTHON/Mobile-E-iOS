//
//  SignupViewController.swift
//  GMakers
//
//  Created by Lee on 2021/08/14.
//

import UIKit

final class SignupViewController: BaseViewController {
  
  struct SignForm {
    
    var id: String = ""
    var password: String = ""
    var check: String = ""
    
    func isEmpty() -> Bool {
      self.id == "" || self.password == "" || self.check == ""
    }
    
    func checkID() -> Bool {
      !self.id.contains(" ")
    }
    
    func checkPasswordCount() -> Bool {
      self.password.count >= 8 || self.check.count >= 8
    }
    
    func checkPassword() -> Bool {
      self.password == self.check
    }
  }
  
  
  
  // MARK: - Property
  
  private var signupForm = SignForm() {
    didSet {
      self.signupButton.backgroundColor = !self.signupForm.isEmpty() ? UIColor.my6540E9 : UIColor.my6540E9.withAlphaComponent(0.2)
    }
  }
  
  private let titleLabel = UILabel()
  private let idView = TextInputView()
  private let pwView = TextInputView()
  private let pwSubLabel = UILabel()
  private let checkView = TextInputView()
  private let signupButton = UIButton()
  
  
  
  // MARK: - Touch
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    
    self.view.endEditing(true)
  }
  
  
  
  // MARK: - Interface
  
  @objc private func textfieldEditing(_ sender: UITextField) {
    guard let text = sender.text else { return }
    
    if sender == self.idView.textField {
      self.signupForm.id = text
      
    } else if sender == self.pwView.textField {
      self.signupForm.password = text
      
    } else {
      self.signupForm.check = text
    }
  }
  
  @objc private func signupDidTap(_ sender: UIButton) {
    guard !self.signupForm.isEmpty() else { return }
    
    guard self.signupForm.checkID() else {
      self.alertBase(title: "경고", message: "아이디에 공백은 불가능합니다", handler: nil)
      return
    }
    
    guard self.signupForm.checkPasswordCount() else {
      self.alertBase(title: "경고", message: "비밀번호 8자 이상 가능합니다", handler: nil)
      return
    }
    
    guard self.signupForm.checkPassword() else {
      self.alertBase(title: "경고", message: "비밀번호가 다릅니다", handler: nil)
      return
    }
    
    let provider = NetworkProvider(path: .signup)
    provider.sign(id: self.signupForm.id, password: self.signupForm.password) { [weak self] result in
      guard let self = self else { return }
      
      DispatchQueue.main.async {
        switch result {
        case .failure(let error):
          self.alertBase(title: "경고", message: error.localizedDescription.description, handler: nil)
          
        case .success(_):
          self.alertBase(title: "완료", message: "가입 완료") { _ in
            self.navigationController?.popViewController(animated: true)
          }
        }
      }
    }
  }
  
  
  
  
  
  // MARK: - UI
  
  override func setNavigation() {
    
  }
  
  override func setAttribute() {
    self.titleLabel.text = "회원가입"
    self.titleLabel.font = UIFont.NotoSansKR.bold(size: 32)
    
    self.idView.titleLabel.text = "아이디"
    
    self.pwView.titleLabel.text = "비밀번호"
    self.pwView.textField.isSecureTextEntry = true
    
    self.pwSubLabel.text = "8자 이상의 영문, 숫자"
    self.pwSubLabel.textColor = UIColor.myA9ACB3
    self.pwSubLabel.font = UIFont.NotoSansKR.regular(size: 12)
    
    self.checkView.titleLabel.text = "비밀번호 확인"
    self.checkView.textField.isSecureTextEntry = true
    
    self.signupButton.setTitle("가입하기", for: .normal)
    self.signupButton.setTitleColor(.white, for: .normal)
    self.signupButton.layer.cornerRadius = 4
    self.signupButton.backgroundColor = UIColor.my6540E9.withAlphaComponent(0.2)
    self.signupButton.addTarget(self, action: #selector(self.signupDidTap(_:)), for: .touchUpInside)
    
    [self.idView, self.pwView, self.checkView].forEach {
      $0.textField.addTarget(self, action: #selector(self.textfieldEditing(_:)), for: .editingChanged)
    }
  }
  
  override func setConstraint() {
    [self.titleLabel, self.idView, self.pwView, self.pwSubLabel, self.checkView, self.signupButton].forEach {
      self.view.addSubview($0)
    }
    
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeArea.top)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(42)
    }
    
    self.idView.snp.makeConstraints { make in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(32)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(62)
    }
    
    self.pwView.snp.makeConstraints { make in
      make.top.equalTo(self.idView.snp.bottom).offset(24)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(62)
    }
    
    self.pwSubLabel.snp.makeConstraints { make in
      make.top.equalTo(self.pwView.snp.bottom)
      make.leading.equalTo(self.pwView)
    }
    
    self.checkView.snp.makeConstraints { make in
      make.top.equalTo(self.pwSubLabel.snp.bottom).offset(24)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(62)
    }
    
    self.signupButton.snp.makeConstraints { make in
      make.top.equalTo(self.checkView.snp.bottom).offset(32)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(54)
    }
    
  }
}

//
//  MainViewController.swift
//  GMakers
//
//  Created by Lee on 2021/08/06.
//

import UIKit

class MainViewController: BaseViewController {
  
  // MARK: - Property
  
  private let button = UIButton()
  
  
  
  
  
  // MARK: - Interface
  
  @objc private func signoutDidTap(_ sender: UIButton) {
    UserDefaultsManager.token = nil
    WindowManager.set(.splash)
  }
  
  
  
  
  // MARK: - UI
  
  override func setAttribute() {
    self.button.setTitle("Sign out", for: .normal)
    self.button.backgroundColor = .red
    self.button.addTarget(self, action: #selector(signoutDidTap(_:)), for: .touchUpInside)
  }
  
  override func setConstraint() {
    [self.button].forEach {
      self.view.addSubview($0)
    }
    
    self.button.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}

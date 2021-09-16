//
//  ProfileBaseViewController.swift
//  GMakers
//
//  Created by Lee on 2021/09/06.
//

import UIKit

class ProfileBaseViewController: BaseViewController {
  
  
  // MARK: - Property
  
  let backButton = UIButton()
  let naviLabel = UILabel()
  let progressbar = UIProgressView()
  let scrollView = UIScrollView()
  
  
  
  // MARK: - Interface
  
  @objc private func backDidTap(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  
  
  // MARK: - UI
  
  override func setAttribute() {
    self.backButton.setImage(UIImage(named: "back_black"), for: .normal)
    self.backButton.addTarget(self, action: #selector(self.backDidTap(_:)), for: .touchUpInside)
    
    self.naviLabel.text = "프로필 생성"
    self.naviLabel.font = UIFont.NotoSansKR.bold(size: 32)
    
    self.progressbar.progressTintColor = UIColor.my9D6EFF
    self.progressbar.backgroundColor = UIColor.myEAEDEF
    
    self.scrollView.showsVerticalScrollIndicator = false
    self.scrollView.showsHorizontalScrollIndicator = false
  }
  
  override func setConstraint() {
    [self.backButton, self.naviLabel, self.progressbar, self.scrollView].forEach {
      self.view.addSubview($0)
    }
    
    self.backButton.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeAreaLayoutGuide).offset(18)
      make.leading.equalToSuperview().inset(20)
      make.width.height.equalTo(24)
    }
    
    self.naviLabel.snp.makeConstraints { make in
      make.top.equalTo(self.backButton.snp.bottom).offset(18)
      make.leading.equalToSuperview().offset(20)
    }
    
    self.progressbar.snp.makeConstraints { make in
      make.top.equalTo(self.naviLabel.snp.bottom).offset(16)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(8)
    }
    
    self.scrollView.snp.makeConstraints { make in
      make.top.equalTo(self.progressbar.snp.bottom).offset(24)
      make.leading.trailing.equalToSuperview()
    }
    
    self.bottomViewConstraint = self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
    self.bottomViewConstraint?.isActive = true
  }
}

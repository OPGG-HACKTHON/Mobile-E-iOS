//
//  MainViewController.swift
//  GMakers
//
//  Created by Lee on 2021/08/06.
//

import UIKit

final class MainViewController: BaseViewController {
  
  // MARK: - Property
  
  private let naviView = UIView()
  private let logoLabel = UILabel()
  private let plusButton = UIButton()
  private let menuButton = UIButton()
  private let searchTextField = UITextField()
  private let searchIconImageView = UIImageView()
  private let myCardButton = UIButton()
  private let bookmarkButton = UIButton()
  private let indicatorView = UIView()
  private let cardTableView = UITableView()
  
  
  
  
  // MARK: - Interface
  
//  @objc private func signoutDidTap(_ sender: UIButton) {
//    UserDefaultsManager.token = nil
//    WindowManager.set(.splash)
//  }
  
  
  @objc private func addDidTap(_ sender: UIButton) {
    let vcAdd1Profile = ProfileAdd1ViewController()
    self.navigationController?.pushViewController(vcAdd1Profile, animated: true)
  }
  
  @objc private func buttonDidTap(_ sender: UIButton) {
    self.myCardButton.isSelected = self.myCardButton == sender
    self.bookmarkButton.isSelected = self.bookmarkButton == sender
    
    let offset = self.myCardButton == sender ? 0 : 60
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      guard let self = self else { return }
      self.indicatorView.snp.updateConstraints { make in
        make.leading.equalTo(self.myCardButton).offset(offset)
      }
      self.view.layoutIfNeeded()
    }
  }
  
  
  
  
  // MARK: - UI
  
  override func setNavigation() {
    self.navigationController?.navigationBar.isHidden = true
  }
  
  override func setAttribute() {
    self.logoLabel.text = "G-MAKERS"
    self.logoLabel.font = UIFont.Azonix.base(size: 16)
    self.logoLabel.textColor = UIColor.my6540E9
    
    self.plusButton.setImage(UIImage(named: "main_add"), for: .normal)
    self.plusButton.addTarget(self, action: #selector(self.addDidTap(_:)), for: .touchUpInside)
    
    self.menuButton.setImage(UIImage(named: "main_menu"), for: .normal)
    
    self.searchTextField.backgroundColor = UIColor(red: 0.918, green: 0.93, blue: 0.937, alpha: 1)
    self.searchTextField.layer.cornerRadius = 4
    
    self.searchIconImageView.image = UIImage(named: "main_search")
    
    self.myCardButton.setTitle("내 카드", for: .normal)
    self.myCardButton.isSelected = true
    
    self.bookmarkButton.setTitle("북마크", for: .normal)
    
    [self.myCardButton, self.bookmarkButton].forEach {
      $0.titleLabel?.font = UIFont.NotoSansKR.black(size: 16)
      $0.setTitleColor(.black, for: .selected)
      $0.setTitleColor(.lightGray, for: .normal)
      $0.addTarget(self, action: #selector(self.buttonDidTap(_:)), for: .touchUpInside)
    }
    
    self.indicatorView.backgroundColor = UIColor.my6540E9
    
    self.cardTableView.dataSource = self
    self.cardTableView.delegate = self
    self.cardTableView.separatorStyle = .none
  }
  
  override func setConstraint() {
    [self.naviView, self.searchTextField, self.searchIconImageView, self.myCardButton, self.bookmarkButton, self.indicatorView, self.cardTableView].forEach {
      self.view.addSubview($0)
    }
    
    self.naviView.snp.makeConstraints { make in
      make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      make.height.equalTo(60)
    }
    
    [self.logoLabel, self.plusButton, self.menuButton].forEach {
      self.naviView.addSubview($0)
    }
    
    self.logoLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(20)
    }
    
    self.plusButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalTo(self.menuButton.snp.leading).offset(-10)
    }
    
    self.menuButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalTo(-10)
    }
    
    self.searchTextField.snp.makeConstraints { make in
      make.top.equalTo(self.naviView.snp.bottom)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(44)
    }
    
    self.searchIconImageView.snp.makeConstraints { make in
      make.centerY.equalTo(self.searchTextField)
      make.trailing.equalTo(self.searchTextField.snp.trailing).offset(-20)
    }
    
    self.myCardButton.snp.makeConstraints { make in
      make.top.equalTo(self.searchTextField.snp.bottom).offset(32)
      make.leading.equalTo(20)
      make.width.equalTo(60)
      make.height.equalTo(28)
    }
    
    self.bookmarkButton.snp.makeConstraints { make in
      make.top.equalTo(self.searchTextField.snp.bottom).offset(32)
      make.leading.equalTo(self.myCardButton.snp.trailing)
      make.width.equalTo(60)
      make.height.equalTo(28)
    }
    
    self.indicatorView.snp.makeConstraints { make in
      make.top.equalTo(self.myCardButton.snp.bottom)
      make.leading.equalTo(self.myCardButton.snp.leading)
      make.width.equalTo(60)
      make.height.equalTo(2)
    }
    
    self.cardTableView.snp.makeConstraints { make in
      make.top.equalTo(self.indicatorView.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }
}


extension MainViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    UITableViewCell()
  }
}



extension MainViewController: UITableViewDelegate {
  
}

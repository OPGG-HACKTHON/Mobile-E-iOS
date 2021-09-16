//
//  SearchViewController.swift
//  GMakers
//
//  Created by Lee on 2021/09/15.
//

import UIKit

import Alamofire
import SnapKit

final class SearchViewController: BaseViewController {
  
  private let naviView = UIView()
  private let backButton = UIButton()
  private let naviLabel = UILabel()
  private let searchTextField = PaddingTextField()
  private let searchImageView = UIImageView()
  private let errorLabel = UILabel()
  private var profileView: SearchProfileView! {
    didSet {
      self.errorLabel.isHidden = self.profileView != nil
    }
  }
  
  private var profileID: Int?
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    self.searchTextField.becomeFirstResponder()
  }
  
  
  
  // MARK: - Interface
  
  private func getProfile(name: String) {
    if self.profileView != nil {
      self.profileView.snp.removeConstraints()
      self.profileView.removeFromSuperview()
      self.profileView = nil
      self.profileID = nil
    }
    
    let param = ["summonerName": name]
    
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(UserDefaultsManager.token!)",
      "Content-Type": "application/json"
    ]
    
    AF.request("http://52.79.197.237:8080/api/profiles",
               method: .get,
               parameters: param,
               headers: headers).response { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .failure(let error):
                  self.alertBase(title: "error", message: error.localizedDescription, handler: nil)
                  
                case .success(let data):
                  guard
                    let temp = data,
                    let profileCard = try? JSONDecoder().decode([ProfileCardModel].self, from: temp)
                  else {
                    self.alertBase(title: "다시 시도해 주세요", message: nil, handler: nil)
                    return
                  }
                  
                  switch profileCard.isEmpty {
                  case true:
                    self.alertBase(title: "계정 인증된 소환사가 아닙니다.", message: nil, handler: nil)
                    
                  case false:
                    self.profileID = profileCard[0].profileID
                    
                    let vProfile = SearchProfileView()
                    self.profileView = vProfile
                    let tap = UITapGestureRecognizer()
                    tap.addTarget(self, action: #selector(self.profileDidTap(_:)))
                    self.profileView.addGestureRecognizer(tap)
                    vProfile.bind(data: profileCard[0])
                    self.view.addSubview(vProfile)
                    vProfile.snp.makeConstraints { make in
                      make.top.equalTo(self.searchTextField.snp.bottom).offset(24)
                      make.leading.trailing.equalToSuperview().inset(20)
                      let multi = 104 * self.view.frame.width / 334
                      make.height.equalTo(multi)
                    }
                  }
                }
               }
  }
  
  
  
  // MARK: - Action
  
  @objc private func backDidTap(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func searchReturn(_ sender: UITextField) {
    guard let text = sender.text, !text.isEmpty else {
      self.alertBase(title: "소환사명을 입력해주세요", message: nil, handler: nil)
      return
    }
    self.getProfile(name: text)
  }
  
  @objc private func profileDidTap(_ sender: UITapGestureRecognizer) {
    guard let profileID = self.profileID else { return }
    
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(UserDefaultsManager.token!)",
      "Content-Type": "application/json"
    ]
    
    self.presentIndicatorViewController()
    
    AF.request(
      "http://52.79.197.237:8080/api/profiles/\(profileID)",
      method: .get,
      parameters: nil,
      headers: headers).response { [weak self] response in
        guard let self = self else { return }
        
        self.dismissIndicatorViewController()
        
        switch response.result {
        case .failure(let error):
          self.alertBase(title: "error", message: error.localizedDescription, handler: nil)
          
        case .success(let data):
          guard
            let temp = data,
            let profileInfo = try? JSONDecoder().decode(ProfileInfoModel.self, from: temp)
          else {
            self.alertBase(title: "error", message: nil, handler: nil)
            return
          }
          
          let vc = ProfileViewController(data: profileInfo)
          self.navigationController?.pushViewController(vc, animated: true)
        }
       }
  }
  
  
  
  // MARK: - UI
  
  override func setAttribute() {
    self.backButton.setImage(UIImage(named: "back_black"), for: .normal)
    self.backButton.addTarget(self, action: #selector(self.backDidTap(_:)), for: .touchUpInside)
    
    self.naviLabel.text = "검색"
    self.naviLabel.font = UIFont.NotoSansKR.medium(size: 16)
    
    self.searchTextField.placeholder = "소환사검색"
    self.searchTextField.backgroundColor = .myEAEDEF
    self.searchTextField.layer.cornerRadius = 4
    self.searchTextField.font = UIFont.NotoSansKR.medium(size: 12)
    self.searchTextField.addTarget(self, action: #selector(self.searchReturn(_:)), for: .editingDidEndOnExit)
    
    self.searchImageView.image = UIImage(named: "main_search")
    
    self.errorLabel.isHidden = true
    self.errorLabel.text = "검색 결과가 없습니다. 정확히 입력해주세요."
    self.errorLabel.textColor = .myFF5D5D
    self.errorLabel.font = UIFont.NotoSansKR.medium(size: 12)
  }
  
  override func setConstraint() {
    [self.naviView, self.searchTextField, self.searchImageView, self.errorLabel].forEach {
      self.view.addSubview($0)
    }
    
    [self.backButton, self.naviLabel].forEach {
      self.naviView.addSubview($0)
    }
    
    self.naviView.snp.makeConstraints { make in
      make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      make.height.equalTo(60)
    }
    
    self.backButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(20)
    }
    
    self.naviLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    self.searchTextField.snp.makeConstraints { make in
      make.top.equalTo(self.naviView.snp.bottom)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(44)
    }
    
    self.searchImageView.snp.makeConstraints { make in
      make.centerY.equalTo(self.searchTextField)
      make.trailing.equalTo(self.searchTextField.snp.trailing).offset(-20)
    }
    
    self.errorLabel.snp.makeConstraints { make in
      make.top.equalTo(self.searchTextField.snp.bottom).offset(8)
      make.leading.equalTo(38)
    }
  }
}

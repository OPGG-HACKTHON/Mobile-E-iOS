//
//  ProfileVerify1ViewController.swift
//  GMakers
//
//  Created by Lee on 2021/09/12.
//

import UIKit

import Alamofire

final class ProfileVerify1ViewController: ProfileBaseViewController {
  
  private let titleLabel = UILabel()
  private let iconImageView = UIImageView()
  private let resetButton = UIButton()
  private let errorLabel = UILabel()
  private let checkButton = UIButton()
  
  var profileCard: ProfileCardModel?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.getIconID()
  }
  
  
  
  // MARK: - Interface
  
  private func getIconID() {
    self.presentIndicatorViewController()
    
    let param = ["summonerId": self.profileCard!.summonerID]
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(UserDefaultsManager.token!)",
      "Content-Type": "application/json"
    ]
    
    AF.request("http://52.79.197.237:8080/api/profiles/auth",
               method: .patch,
               parameters: param,
               encoding: JSONEncoding.default,
               headers: headers).responseJSON { [weak self] response in
                guard let self = self else { return }
                
                self.dismissIndicatorViewController()
                
                switch response.result {
                case .failure(let error):
                  self.alertBase(title: "error", message: error.localizedDescription, handler: nil)
                  
                case .success(let data):
                  guard
                    let temp = data as? [String: Int],
                    let iconID = temp["iconId"]
                  else { return }
                  
                  let imageName = "profileicon_" + String(iconID)
                  self.iconImageView.image = UIImage(named: imageName)
                }
               }
  }
  
  private func checkIconID() {
    self.presentIndicatorViewController()
    
    let param = ["summonerId": self.profileCard!.summonerID]
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(UserDefaultsManager.token!)",
      "Content-Type": "application/json"
    ]
    
    AF.request("http://52.79.197.237:8080/api/profiles/auth-confirm",
               method: .patch,
               parameters: param,
               encoding: JSONEncoding.default,
               headers: headers).responseJSON { [weak self] response in
                guard let self = self else { return }
                
                self.dismissIndicatorViewController()
                self.isChecking = false
                
                switch response.result {
                case .failure(let error):
                  self.alertBase(title: "error", message: error.localizedDescription, handler: nil)
                  
                case .success(let data):
                  guard
                    let temp = data as? [String: Bool],
                    let isCertified = temp["certified"],
                    isCertified
                  else {
                    self.errorLabel.isHidden = false
                    return
                  }
                  
                  let vc = ProfileVerify2ViewController()
                  vc.profileCard = self.profileCard
                  self.navigationController?.pushViewController(vc, animated: true)
                }
               }
  }
  
  private var isChecking = false {
    didSet {
      self.stateButtonUpdate()
    }
  }
  private func stateButtonUpdate() {
    let buttonTitle = self.isChecking ? "확인중..." : "변경했습니다."
    self.checkButton.setTitle(buttonTitle, for: .normal)
    self.checkButton.alpha = self.isChecking ? 0.2 : 1
  }
  
  
  
  // MARK: - Action
  
  @objc private func resetDidTap(_ sender: UIButton) {
    self.getIconID()
  }
  
  @objc private func checkDidTap(_ sender: UIButton) {
    self.checkIconID()
    self.isChecking = true
  }
  
  
  
  // MARK: - UI
  
  override func setAttribute() {
    super.setAttribute()
    
    self.naviLabel.text = "계정 인증"
    
    self.progressbar.progress = 1 / 2
    
    self.titleLabel.text = "1. 소환사 아이콘을 제시된 이미지로 변경해주세요."
    self.titleLabel.textColor = .my878991
    self.titleLabel.font = UIFont.NotoSansKR.bold(size: 14)
    
    self.iconImageView.contentMode = .scaleAspectFit
    
    let attribute = NSMutableAttributedString.create(text: "다른 소환사 아이폰 새로고침", keyWord: "새로고침", keyWordColor: .my1F10B5)
    self.resetButton.titleLabel?.font = UIFont.NotoSansKR.medium(size: 12)
    self.resetButton.setAttributedTitle(attribute, for: .normal)
    self.resetButton.addTarget(self, action: #selector(self.resetDidTap(_:)), for: .touchUpInside)
    
    self.errorLabel.isHidden = true
    self.errorLabel.text = "입력 값이 올바르지 않습니다. 다시 한번 확인해 주세요."
    self.errorLabel.textColor = .myFF5D5D
    self.errorLabel.textAlignment = .center
    self.errorLabel.font = UIFont.NotoSansKR.black(size: 14)
    self.errorLabel.adjustsFontSizeToFitWidth = true
    
    self.checkButton.backgroundColor = .my6540E9
    self.checkButton.setTitle("변경했습니다", for: .normal)
    self.checkButton.setTitleColor(.white, for: .normal)
    self.checkButton.layer.cornerRadius = 8
    self.checkButton.titleLabel?.font = UIFont.NotoSansKR.bold(size: 14)
    self.checkButton.addTarget(self, action: #selector(self.checkDidTap(_:)), for: .touchUpInside)
  }
  
  override func setConstraint() {
    super.setConstraint()
    
    [self.titleLabel, self.iconImageView, self.resetButton, self.errorLabel, self.checkButton].forEach {
      self.view.addSubview($0)
    }
    
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self.progressbar).offset(48)
      make.leading.equalTo(20)
    }
    
    self.iconImageView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.titleLabel.snp.bottom).offset(24)
      make.width.height.equalTo(210)
    }
    
    self.resetButton.snp.makeConstraints { make in
      make.top.equalTo(self.iconImageView.snp.bottom)
      make.trailing.equalTo(self.iconImageView)
    }
    
    self.errorLabel.snp.makeConstraints { make in
      make.top.equalTo(self.resetButton.snp.bottom).offset(8)
      make.leading.trailing.equalToSuperview().inset(20)
    }
    
    self.checkButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(20)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(24)
      make.height.equalTo(54)
    }
  }
}

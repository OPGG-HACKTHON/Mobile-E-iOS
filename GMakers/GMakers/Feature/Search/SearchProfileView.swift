//
//  SearchProfileView.swift
//  GMakers
//
//  Created by Lee on 2021/09/16.
//

import UIKit

final class SearchProfileView: UIView {
  
  private let iconImageView = UIImageView()
  private let levelLabel = UILabel()
  private let nameLabel = UILabel()
  private let tierLabel = UILabel()
  private let checkImageView = UIImageView()

  
  // MARK: - Life Cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setAttribute()
    self.setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(data: ProfileCardModel) {
    self.iconImageView.image = UIImage(named: "profileicon_\(data.profileIconID)")
    
    self.levelLabel.text = "Lv.\(data.level)"
    
    self.nameLabel.text = data.summonerName
    
    self.tierLabel.text = data.tier
  }
}



// MARK: - UI
extension SearchProfileView {
  
  private func setAttribute() {
    self.backgroundColor = .white
    self.layer.cornerRadius = 12
    self.shadow()
    
    self.iconImageView.contentMode = .scaleAspectFit
    self.iconImageView.layer.cornerRadius = 12
    self.iconImageView.layer.masksToBounds = true
    
    self.levelLabel.textColor = .black
    self.levelLabel.font = UIFont.NotoSansKR.medium(size: 12)
    
    self.nameLabel.textColor = .black
    self.nameLabel.font = UIFont.NotoSansKR.bold(size: 16)
    
    self.tierLabel.textColor = .my878991
    self.tierLabel.font = UIFont.NotoSansKR.bold(size: 16)
    
    self.checkImageView.image = UIImage(named: "search_verified")
    self.checkImageView.contentMode = .scaleAspectFit
  }
  
  private func setConstraint() {
    [self.iconImageView, self.levelLabel, self.nameLabel, self.tierLabel, self.checkImageView].forEach {
      self.addSubview($0)
    }
    
    self.iconImageView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(20)
      make.width.height.equalTo(77)
    }
    
    self.levelLabel.snp.makeConstraints { make in
      make.top.equalTo(19)
      make.leading.equalTo(self.iconImageView.snp.trailing).offset(18)
      make.height.equalTo(18)
    }
    
    self.nameLabel.snp.makeConstraints { make in
      make.top.equalTo(self.levelLabel.snp.bottom).offset(2)
      make.leading.equalTo(self.iconImageView.snp.trailing).offset(18)
      make.height.equalTo(22)
    }
    
    self.tierLabel.snp.makeConstraints { make in
      make.top.equalTo(self.nameLabel.snp.bottom).offset(2)
      make.leading.equalTo(self.iconImageView.snp.trailing).offset(18)
      make.height.equalTo(22)
    }
    
    self.checkImageView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalTo(-20)
      make.width.height.equalTo(24)
    }
  }
}

//
//  GCardCollectionViewCell.swift
//  GMakers
//
//  Created by Lee on 2021/09/12.
//

import UIKit

class GCardCollectionViewCell: UICollectionViewCell {

  static let identifier = "GCardCollectionViewCell"
  
  private let backImageView = UIImageView()
  private let tierLabel = UILabel()
  private let gLabel = UILabel()
  private let tierImageView = UIImageView()
  private let verifiedLabel = UILabel()
  private let levelLabel = UILabel()
  private let nameLabel = UILabel()
  private let position1ImageView = UIImageView()
  private let position2ImageView = UIImageView()
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setAttribute()
    self.setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(data: ProfileCardModel) {
    let imageName = data.certified ? "card_1" : "card_0"
    self.backImageView.image = UIImage(named: imageName)
    
    self.tierLabel.text = data.tier
    
    self.tierImageView.image = UIImage(named: data.timerImageName)
    
    self.verifiedLabel.isHidden = data.certified
    
    self.levelLabel.text = "Lv.\(data.level)"
    
    self.nameLabel.text = data.summonerName
    
    data.preferLineImageNames.enumerated().forEach {
      switch $0 {
      case 0:
        self.position1ImageView.image = UIImage(named: $1)
        
      case 1:
        self.position2ImageView.image = UIImage(named: $1)
        
      default:
        break
      }
    }
  }
  
  func bind(data: ProfileVerifyModel, line: [AddPreferLine], isVerify: Bool) {
    let imageName = isVerify ? "card_1" : "card_0"
    self.backImageView.image = UIImage(named: imageName)
    
    self.tierLabel.text = data.tier
    
    self.tierImageView.image = UIImage(named: data.timerImageName)
    
    self.verifiedLabel.isHidden = isVerify
    
    self.levelLabel.text = "Lv.\(data.level)"
    
    self.nameLabel.text = data.summonerName
    
    line.enumerated().forEach {
      let line =  $1.line.lowercased()
      var temp = ""
      switch line {
      case "ad": temp = "bot"
      case "sup": temp = "support"
      default: temp = line
      }
      let imageName = "position_" + data.tier.lowercased() + "-" + temp
      
      switch $0 {
      case 0:
        self.position1ImageView.image = UIImage(named: imageName)
        
      case 1:
        self.position2ImageView.image = UIImage(named: imageName)
        
      default:
        break
      }
    }
  }
  
  func bind(data: ProfileInfoModel) {
    let imageName = data.certified ? "card_1" : "card_0"
    self.backImageView.image = UIImage(named: imageName)
    
    self.tierLabel.text = data.tier
    
    self.tierImageView.image = UIImage(named: data.timerImageName)
    
    self.verifiedLabel.isHidden = data.certified
    
    self.levelLabel.text = "Lv.\(data.level)"
    
    self.nameLabel.text = data.summonerName
    
    data.preferLineImageNames.enumerated().forEach {
      switch $0 {
      case 0:
        self.position1ImageView.image = UIImage(named: $1)
        
      case 1:
        self.position2ImageView.image = UIImage(named: $1)
        
      default:
        break
      }
    }
  }
}



// MARK: - UI
extension GCardCollectionViewCell {
  
  private func setAttribute() {
    self.contentView.layer.cornerRadius = 18
    self.contentView.layer.masksToBounds = true
    
    self.backImageView.contentMode = .scaleAspectFit
    
    self.tierLabel.font = UIFont.Azonix.base(size: 12)
    self.tierLabel.textColor = .white
    
    self.gLabel.text = "G-MAKERS"
    self.gLabel.font = UIFont.Azonix.base(size: 12)
    self.gLabel.textColor = .white
    
    self.verifiedLabel.text = "UNVERIFIED"
    self.verifiedLabel.font = UIFont.Azonix.base(size: 16)
    self.verifiedLabel.textColor = .myFF5D5D
    
    self.levelLabel.font = UIFont.NotoSansKR.medium(size: 12)
    self.levelLabel.textColor = .white
    
    self.nameLabel.font = UIFont.NotoSansKR.bold(size: 16)
    self.nameLabel.textColor = .white
    
    [self.tierImageView, self.position1ImageView, self.position2ImageView].forEach {
      $0.contentMode = .scaleAspectFit
    }
  }
  
  private func setConstraint() {
    [self.backImageView, self.tierLabel, self.gLabel, self.tierImageView, self.verifiedLabel, self.levelLabel, self.nameLabel, self.position1ImageView, self.position2ImageView].forEach {
      self.contentView.addSubview($0)
    }
    
    self.backImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    self.tierLabel.snp.makeConstraints { make in
      make.top.leading.equalToSuperview().inset(24)
    }
    
    self.gLabel.snp.makeConstraints { make in
      make.top.trailing.equalToSuperview().inset(24)
    }
    
    self.tierImageView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.equalTo(120)
      make.height.equalTo(140)
    }
    
    self.verifiedLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    self.levelLabel.snp.makeConstraints { make in
      make.leading.equalToSuperview().inset(24)
      make.bottom.equalTo(self.nameLabel.snp.top)
    }
    
    self.nameLabel.snp.makeConstraints { make in
      make.leading.bottom.equalToSuperview().inset(24)
    }
    
    self.position1ImageView.snp.makeConstraints { make in
      make.trailing.equalTo(self.position2ImageView.snp.leading).offset(-2)
      make.bottom.equalToSuperview().inset(24)
      make.width.height.equalTo(20)
    }
    
    self.position2ImageView.snp.makeConstraints { make in
      make.trailing.bottom.equalToSuperview().inset(24)
      make.width.height.equalTo(20)
    }
    
  }
}


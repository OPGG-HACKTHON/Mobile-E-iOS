//
//  ChampionMasteryCollectionViewCell.swift
//  GMakers
//
//  Created by Lee on 2021/09/16.
//

import UIKit

final class ChampionMasteryCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "ChampionMasteryCollectionViewCell"
  
  private let backImageView = UIImageView()
  private let championImageView = UIImageView()
  private let nameLabel = UILabel()
  private let pointLabel = UILabel()
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setAttribute()
    self.setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(data: PreferChampions) {
    let imageName = "Champion_Mastery_Level_\(data.championLevel)_Square"
    self.backImageView.image = UIImage(named: imageName)
    
    let champion = ChampionManager.allData
      .filter { $0.tag == data.championID }
      .first!
    self.championImageView.image = UIImage(named: champion.en)
    
    self.nameLabel.text = data.championName
    
    let value: NSNumber = data.championPoints as NSNumber
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    let pointString = formatter.string(from: value)
    self.pointLabel.text = pointString
  }
}



// MARK: - UI
extension ChampionMasteryCollectionViewCell {
  private func setAttribute() {
    self.backImageView.contentMode = .scaleAspectFit
    
    self.championImageView.contentMode = .scaleAspectFit
    
    self.nameLabel.font = UIFont.NotoSansKR.bold(size: 14)
    self.nameLabel.textColor = .white
    
    self.pointLabel.font = UIFont.Azonix.base(size: 14)
    self.pointLabel.textColor = .white
  }
  
  private func setConstraint() {
    [self.backImageView, self.championImageView, self.nameLabel, self.pointLabel].forEach {
      self.contentView.addSubview($0)
    }
    
    self.backImageView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
    }
    
    self.championImageView.snp.makeConstraints { make in
      make.top.equalTo(11)
      make.leading.trailing.equalToSuperview().inset(14)
      make.height.equalTo(self.championImageView.snp.width)
    }
    
    self.nameLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.backImageView.snp.bottom)
    }
    
    self.pointLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(self.nameLabel.snp.bottom)
    }
  }
}


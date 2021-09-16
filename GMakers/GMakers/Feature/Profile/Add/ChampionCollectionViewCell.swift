//
//  ChampionCollectionViewCell.swift
//  GMakers
//
//  Created by Lee on 2021/09/12.
//

import UIKit

class ChampionCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "ChampionCollectionViewCell"
  
  let imageView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.imageView.contentMode = .scaleAspectFit
    self.contentView.addSubview(self.imageView)
    self.imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

//
//  IntialCollectionViewCell.swift
//  GMakers
//
//  Created by Lee on 2021/09/12.
//

import UIKit

class IntialCollectionViewCell: UICollectionViewCell {
  
  static let identifier = "IntialCollectionViewCell"
  
  override var isSelected: Bool {
    didSet {
      self.layer.borderColor = self.isSelected ? UIColor.my6540E9.cgColor : UIColor.myA9ACB3.cgColor
      self.titleLabel.textColor = self.isSelected ? .my6540E9 : .my2A292B
    }
  }
  
  let titleLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.layer.cornerRadius = 18
    self.layer.borderWidth = 1
    self.layer.borderColor = UIColor.myA9ACB3.cgColor
    
    self.titleLabel.textColor = .my2A292B
    self.titleLabel.textAlignment = .center
    self.titleLabel.font = UIFont.NotoSansKR.bold(size: 16)
    self.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

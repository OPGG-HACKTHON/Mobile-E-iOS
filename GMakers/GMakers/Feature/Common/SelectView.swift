//
//  SelectView.swift
//  GMakers
//
//  Created by Lee on 2021/09/12.
//

import UIKit

class SelectView: UIView {
  
  let titleLabel = UILabel()
  let arrowImageView = UIImageView()
  
  
  
  // MARK: - Life Cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.layer.cornerRadius = 3
    self.layer.borderWidth = 1.5
    self.layer.borderColor = UIColor.myA9ACB3.cgColor
    
    self.titleLabel.font = UIFont.NotoSansKR.medium(size: 12)
    self.addSubview(self.titleLabel)
    self.titleLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(12)
    }
    
    self.arrowImageView.image = UIImage(named: "arrow_down")
    self.addSubview(self.arrowImageView)
    self.arrowImageView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(4)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}


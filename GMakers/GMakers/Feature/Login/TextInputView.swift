//
//  TextInputView.swift
//  GMakers
//
//  Created by Lee on 2021/08/14.
//

import UIKit
import SnapKit

class TextInputView: UIView {
  
  // MARK: - Property
  
  let titleLabel = UILabel()
  let textField = UITextField()
  let lineView = UIView()
  


  
  // MARK: - Life Cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setAttribute()
    self.setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}



// MARK: - UI
extension TextInputView {
  
  private func setAttribute() {
    self.titleLabel.textColor = UIColor.myA9ACB3
    self.titleLabel.font = UIFont.NotoSansKR.bold(size: 14)
    
    self.textField.font = UIFont.NotoSansKR.regular(size: 16)
    
    self.lineView.backgroundColor = .myCED1D6
  }
  
  private func setConstraint() {
    [self.titleLabel, self.textField, self.lineView].forEach {
      self.addSubview($0)
    }
    
    self.titleLabel.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.height.equalTo(20)
    }
    
    self.textField.snp.makeConstraints { make in
      make.top.equalTo(self.titleLabel.snp.bottom)
      make.leading.trailing.equalToSuperview()
    }
    
    self.lineView.snp.makeConstraints { make in
      make.top.equalTo(self.textField.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(2)
    }
  }
}

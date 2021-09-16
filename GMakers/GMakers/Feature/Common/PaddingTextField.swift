//
//  PaddingTextField.swift
//  GMakers
//
//  Created by Lee on 2021/09/15.
//

import UIKit

class PaddingTextField: UITextField {
  
  private var padding: UIEdgeInsets = UIEdgeInsets(top: 8, left: 24, bottom: 8, right: 48)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setLeftPaddingPoints(16)
    self.setRightPaddingPoints(48)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func drawText(in rect: CGRect) {
    let paddingRect = rect.inset(by: padding)
    super.drawText(in: paddingRect)
  }
  
  override var intrinsicContentSize: CGSize {
    var contentSize = super.intrinsicContentSize
    contentSize.height += padding.top + padding.bottom
    contentSize.width += padding.left + padding.right
    return contentSize
  }
}

extension UITextField {
  func setLeftPaddingPoints(_ amount:CGFloat){ //왼쪽에 여백 주기
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
    self.leftView = paddingView
    self.leftViewMode = .always
  }
  
  func setRightPaddingPoints(_ amount:CGFloat) { //오른쪽에 여백 주기
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
    self.rightView = paddingView
    self.rightViewMode = .always
  }
}

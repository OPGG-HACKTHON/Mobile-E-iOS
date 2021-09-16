//
//  UIViewExtension.swift
//  GMakers
//
//  Created by Lee on 2021/09/16.
//

import UIKit

extension UIView {
  
  var parentViewController: UIViewController? {
    var responder: UIResponder? = self
    while let nextResponder = responder?.next {
      responder = nextResponder
      if let vc = nextResponder as? UIViewController {
        return vc
      }
    }
    return nil
  }
  
  func shadow() {
    self.layer.shadowRadius = 5.0
    self.layer.shadowOpacity = 0.2
    self.layer.shadowOffset = .zero
    self.layer.shadowColor = UIColor.darkGray.cgColor
  }
}

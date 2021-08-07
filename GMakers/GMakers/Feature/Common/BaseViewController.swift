//
//  BaseViewController.swift
//  GMakers
//
//  Created by Lee on 2021/08/06.
//

import UIKit

import SnapKit

class BaseViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    
    self.setNavigation()
    self.setAttribute()
    self.setConstraint()
  }
  
  func setNavigation() {}
  func setAttribute() {}
  func setConstraint() {}
}

//
//  BaseViewController.swift
//  GMakers
//
//  Created by Lee on 2021/08/06.
//

import UIKit

import Alamofire
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
  
  
  
  // MARK: - AlertController
  
  struct AlertAction {
    let title: String
    let style: UIAlertAction.Style
    let handler: ((UIAlertAction) -> Void)?
    
    init(title: String,
         style: UIAlertAction.Style = .default,
         handler: ((UIAlertAction) -> Void)? = nil) {
      self.title = title
      self.style = style
      self.handler = handler
    }
  }
  
  func alertBase(title: String? = nil, message: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cancel = UIAlertAction(title: "닫기", style: .cancel, handler: handler)
    alert.addAction(cancel)
    self.present(alert, animated: true)
  }
  
  func alertMulit(title: String? = nil, message: String? = nil, style: UIAlertController.Style = .alert, actions: [AlertAction]) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
    
    for action in actions {
      let tempAction = UIAlertAction(title: action.title, style: action.style, handler: action.handler)
      alertController.addAction(tempAction)
    }
    
    self.present(alertController, animated: true)
  }
}

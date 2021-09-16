//
//  BaseViewController.swift
//  GMakers
//
//  Created by Lee on 2021/08/06.
//

import UIKit

import SnapKit

class BaseViewController: UIViewController {
  
  var bottomViewConstraint: NSLayoutConstraint?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    
    self.setNavigation()
    self.setAttribute()
    self.setConstraint()
    
    self.addKeyboardNotification()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
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
  
  
  
  // MARK: - Keyboard
  
  func addKeyboardNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotificationAction(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotificationAction(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  @objc private func keyboardNotificationAction(_ notification: Notification) {
    guard
      let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
      let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
      let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
      else { return }
    let height = keyboardFrame.cgRectValue.height - view.safeAreaInsets.bottom
    
    UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: curve), animations: { [weak self] in
      guard let self = self else { return }
      
      switch notification.name {
      case UIResponder.keyboardWillShowNotification:
        self.bottomViewConstraint?.constant = -height
        
      case UIResponder.keyboardWillHideNotification:
        self.bottomViewConstraint?.constant = 0
        
      default:
        break
      }
      self.view.layoutIfNeeded()
    })
  }
  
  
  
  // MARK: - IndicatoerViewController
  
  func presentIndicatorViewController() {
    let vcIndicator = IndicatorViewController()
    vcIndicator.modalPresentationStyle = .overFullScreen
    present(vcIndicator, animated: false)
  }
  
  func dismissIndicatorViewController() {
    guard let vcIndicator = presentedViewController as? IndicatorViewController else { return }
    vcIndicator.dismiss(animated: false)
  }
}
